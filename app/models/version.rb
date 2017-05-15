class Version
  include Comparable

  MATCHER = /\A
    (?<major>\d+)\.
    (?<minor>\d+)\.
    (?<patch>\d+)
  \z/x

  def initialize(raw)
    @raw = raw
  end

  def parsed
    @parsed ||= begin
      matches = @raw.match(MATCHER)
      names   = matches.names
      values  = matches.captures.map(&:to_i)

      Hash[names.zip(values)].symbolize_keys
    end
  end

  def <=>(other)
    to_a <=> other.to_a
  end

  def to_a
    [parsed[:major], parsed[:minor], parsed[:patch]]
  end

  def to_s
    @raw
  end
end
