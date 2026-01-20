class ApplicationController < ActionController::Base
  before_action :set_default_format

  private

  def set_default_format
    request.format = :html
  end
end
