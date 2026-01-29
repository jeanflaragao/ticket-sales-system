require_relative 'boot'

require 'rails'
require 'active_model/railtie'
require 'active_job/railtie'
require 'active_record/railtie'
require 'active_storage/engine'
require 'action_controller/railtie'
require 'action_mailer/railtie'
require 'action_mailbox/engine'
require 'action_cable/engine'
require 'action_view/railtie'
# Skip ActionText for API-only app to avoid frozen array issues
# require 'action_text/engine'
require 'rails/test_unit/railtie'

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
