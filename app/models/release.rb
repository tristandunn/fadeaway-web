class Release < ActiveRecord::Base
  PATH_FORMAT      = "releases/Fadeaway-%s.%s".freeze
  VALID_EXTENSIONS = %w(dmg zip).freeze
  DEFAULT_LOGS     = {
    "additions" => [],
    "changes"   => [],
    "fixes"     => [],
    "removed"   => []
  }.freeze

  before_validation :assign_defaults
  before_validation :ensure_uploaded, on: :update

  validates :description, presence: true
  validates :version,     presence: true, format: { with: Version::MATCHER }

  def self.latest
    ordered_by_version.released.first
  end

  def self.released
    where.not(released_at: nil)
  end

  def self.since(version)
    where(
      "string_to_array(version, '.')::int[] > string_to_array(?, '.')::int[]",
      version
    ).ordered_by_version
  end

  def self.ordered_by_version
    order("string_to_array(version, '.')::int[] DESC")
  end

  def bucket
    @bucket ||= Aws::S3::Bucket.new("getfadeaway")
  end

  def ensure_uploaded
    return unless releasing?
    return if     uploaded?

    errors.add(:released_at, "can not be set without uploaded files")
  end

  def releasing?
    released_at_was.nil? && released_at.present?
  end

  def uploaded?
    VALID_EXTENSIONS.all? do |extension|
      bucket.object(format(PATH_FORMAT, version, extension)).exists?
    end
  end

  def url(extension = :zip)
    unless extension.to_s.in?(VALID_EXTENSIONS)
      extension = :zip
    end

    file = bucket.object(format(PATH_FORMAT, version, extension))
    file.presigned_url(:get, expires_in: 30.seconds)
  end

  protected

  def assign_defaults
    self.logs ||= DEFAULT_LOGS
  end
end
