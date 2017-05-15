lock "3.6.1"

# Application name and deployment location.
set :repo_url,    "git@gitlab.com:tristandunn/fadeaway-web.git"
set :deploy_to,   "/var/www/getfadeaway.com"
set :application, "getfadeaway"

# Allow branch deployment.
set :branch, ENV["BRANCH"] || "master"

# Always deploy as a production environment.
set :rails_env, "production"

# Keep previous three releases.
set :keep_assets,   3
set :keep_releases, 3

# Ensure bundler is run for the web role.
set :bundle_roles, :web

# Location and settings for rbenv environment.
set :rbenv_type,        :system
set :rbenv_ruby,        "2.2.3"
set :rbenv_roles,       :all
set :rbenv_map_bins,    %w(bundle gem rake ruby)
set :rbenv_custom_path, "/opt/rbenv"

# Link shared directories and files.
set :linked_dirs,  fetch(:linked_dirs, []).push("log", "tmp/pids", "tmp/cache")
set :linked_files, fetch(:linked_files, []).push(".env")

# Set a custom maintenance page.
set :maintenance_template_path,
    File.join(
      File.expand_path("../../app/views/layouts", __FILE__),
      "maintenance.html.erb"
    )

namespace :unicorn do
  desc "Start the unicorn server"
  task :start do
    on roles(:web) do
      execute :sh, "/etc/init.d/unicorn start"
    end
  end

  desc "Stop the unicorn server"
  task :stop do
    on roles(:web) do
      execute :sh, "/etc/init.d/unicorn stop"
    end
  end

  desc "Restart the unicorn server"
  task :restart do
    on roles(:web) do
      execute :sh, "/etc/init.d/unicorn restart"
    end
  end
end

after "deploy:publishing", "unicorn:restart"
