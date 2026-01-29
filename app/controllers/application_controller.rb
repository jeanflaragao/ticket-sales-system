class ApplicationController < ActionController::Base
  before_action :set_default_format
  protect_from_forgery with: :null_session, if: -> { request.format.json? }

  private

  def set_default_format
    request.format = :json if request.path.start_with?('/orders',
                                                       '/shows') && request.format == :html
  end
end
