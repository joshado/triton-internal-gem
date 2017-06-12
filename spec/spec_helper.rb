require "bundler/setup"
require "triton"

RSpec.configure do |config|
  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = ".rspec_status"

  config.before do
    Triton.test_mode = false
    Triton.suffix = "test"
  end

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end
end
