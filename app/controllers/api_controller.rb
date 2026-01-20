# app/controllers/api_controller.rb
class ApiController < ActionController::API
  # Note: ActionController::API doesn't include CSRF protection by default
  # This is appropriate for API-only applications

  before_action :set_default_format

  private

  def set_default_format
    request.format = :json
  end
end
