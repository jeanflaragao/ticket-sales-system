if Rails.env.test?
  ActionController::Base.allow_forgery_protection = false

  # Ensure test environment properly handles API requests
  Rails.application.config.api_only = false # Allow both HTML and JSON responses

  # Configure middleware stack for test environment
  Rails.application.configure do
    config.middleware.delete ActionDispatch::Flash
  end
end
