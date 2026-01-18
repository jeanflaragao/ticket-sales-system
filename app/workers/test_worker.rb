class TestWorker
  include Sidekiq::Worker
  
  def perform(name)
    puts "Hello from Sidekiq, #{name}!"
    Rails.logger.info("TestWorker executed for #{name}")
  end
end
