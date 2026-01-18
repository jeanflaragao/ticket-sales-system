class ApplicationController < ActionController::API
  # Global error handling
  rescue_from ActiveRecord::RecordNotFound, with: :not_found
  rescue_from ActionController::ParameterMissing, with: :bad_request
  rescue_from ActiveRecord::RecordInvalid, with: :unprocessable_entity
  
  # Before actions (run before every action)
  before_action :set_default_format
  
  private
  
  def set_default_format
    request.format = :json
  end
  
  def not_found(exception)
    render json: { 
      error: "Not found", 
      message: exception.message 
    }, status: :not_found
  end
  
  def bad_request(exception)
    render json: { 
      error: "Bad request", 
      message: exception.message 
    }, status: :bad_request
  end
  
  def unprocessable_entity(exception)
    render json: { 
      error: "Validation failed", 
      errors: exception.record.errors.full_messages 
    }, status: :unprocessable_entity
  end
end