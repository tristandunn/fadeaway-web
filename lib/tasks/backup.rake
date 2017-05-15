namespace :backup do
  desc "Backup the production database"
  task :database do
    path      = Rails.root.join("config/backup/config.rb")
    variables = Dotenv.load.map do |key, value|
      [key, value].join("=")
    end.join(" ")

    Bundler.with_clean_env do
      `#{variables} backup perform -c '#{path}' -t database`
    end
  end
end
