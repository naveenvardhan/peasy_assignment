class UserImportWorker
  include Sidekiq::Worker
  sidekiq_options retry: false

  def perform
    user_count = User.import_users

    date = Date.current.strftime('%Y-%m-%d')
    time = Time.now.strftime('%H')
    
    male_count_key = "male_count:#{date}"
    female_count_key = "female_count:#{date}"

    $redis.hincrby(male_count_key, time, user_count[:male_count])
    $redis.hincrby(female_count_key, time, user_count[:female_count])
  end

end