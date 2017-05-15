Model.new(:database, "Production database backup.") do
  PATH     = "/var/www/getfadeaway.com/current/config/database.yml".freeze
  DATABASE = YAML.load_file(PATH)["production"]

  database PostgreSQL do |db|
    db.host     = DATABASE["host"]
    db.name     = DATABASE["database"]
    db.username = DATABASE["username"]
    db.password = DATABASE["password"]
  end

  compress_with Gzip

  store_with S3 do |s3|
    s3.access_key_id     = ENV["AWS_ACCESS_KEY_ID"]
    s3.secret_access_key = ENV["AWS_SECRET_ACCESS_KEY"]
    s3.region            = "us-east-1"
    s3.bucket            = "getfadeaway"
    s3.path              = "backups/"
    s3.keep              = 30
  end
end
