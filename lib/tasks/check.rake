namespace :check do
  desc "Check the code, without coverage"
  task code: [:spec, :rubocop, :scss_lint]

  desc "Check the code, with coverage"
  task :coverage do
    ENV["COVERAGE"] = "true"

    Rake::Task["check:code"].invoke
  end
end

desc "Check the code"
task check: ["check:coverage"]
