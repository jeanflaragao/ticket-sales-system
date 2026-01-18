require "connection_pool"

REDIS_CONFIG = {
  url: ENV.fetch("REDIS_URL", "redis://localhost:6379/0"),
  timeout: 5,
  reconnect_attempts: 3
}

REDIS_POOL = ConnectionPool.new(size: 25, timeout: 5) do
  Redis.new(REDIS_CONFIG)
end
