# app/controllers/api_controller.rb
class ApiController < ActionController::API
  # NOTE: ActionController::API doesn't include CSRF protection by default
  # This is appropriate for API-only applications

  include ActionController::MimeResponds

  before_action :set_default_format
  rescue_from ActiveRecord::RecordNotFound, with: :record_not_found

  private

  def set_default_format
    request.format = :json
  end

  def record_not_found
    render json: { error: 'Record not found' }, status: :not_found
  end
end
