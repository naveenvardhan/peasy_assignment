class DailyReportWorker
  include Sidekiq::Worker
  sidekiq_options retry: false

  def perform
    User.create_records
  end

end