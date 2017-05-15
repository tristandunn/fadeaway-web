set :output, "/var/www/getfadeaway.com/shared/log/whenever.log"

every 1.day, at: "4 AM" do
  rake "backup:database"
end
