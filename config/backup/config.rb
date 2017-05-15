#
# Backup v4.x Configuration
#

Logger.configure do
  console.quiet = false

  logfile.enabled   = true
  logfile.log_path  = "/var/www/getfadeaway.com/shared/log"
  logfile.max_bytes = 524_288
end
