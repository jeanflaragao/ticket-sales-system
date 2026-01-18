class TestWorker2
  include Sidekiq::Worker
  
  def perform(name)
    puts "Hello from Sidekiq 2, #{name}!"
    Rails.logger.info("TestWorker 2 executed for #{name}")
  end
end
