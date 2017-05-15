begin
  require "scss_lint/rake_task"

  SCSSLint::RakeTask.new
rescue LoadError # rubocop:disable Lint/HandleExceptions
end
