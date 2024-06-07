class DailyReportWorker
  include Sidekiq::Worker
  sidekiq_options retry: false

  def perform
    current_date = Date.current
    date = current_date.strftime('%Y-%m-%d')

    male_count = 0
    female_count = 0
    male_count_key = "male_count:#{date}"
    female_count_key = "female_count:#{date}"
    (0..23).each do |time|
      male_count += $redis.hget(male_count_key, time).to_i
      female_count += $redis.hget(female_count_key, time).to_i
    end

    DailyRecord.create_record(current_date, male_count, female_count)
  end

end