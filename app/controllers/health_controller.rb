class HealthController < ApplicationController
  def show
    render json: {
      status: 'ok',
      timestamp: Time.current.iso8601,
      services: {
        database: database_healthy?,
        redis: redis_healthy?
      }
    }
  end

  private

  def database_healthy?
    ActiveRecord::Base.connection.active?
  rescue StandardError
    false
  end

  def redis_healthy?
    Redis.new(url: ENV['REDIS_URL']).ping == 'PONG'
  rescue StandardError
    false
  end
end