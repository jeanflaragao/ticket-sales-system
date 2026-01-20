require_relative "boot"

require "rails/all"

# Require the gems listed in Gemfile, including any gems
# you\'ve limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module TicketSalesSystem
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 7.1

    # Don\'t generate system test files
    config.generators.system_tests = nil

    # Only loads a smaller set of middleware suitable for API only apps.
    config.api_only = true
    
    # Fix frozen array issue in tests
    config.autoload_lib(ignore: %w[assets tasks])
  end
end