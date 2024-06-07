class DailyRecord < ApplicationRecord
  include ActiveModel::Dirty
  
  def self.create_record(date, male_count, female_count)
    daily_record = DailyRecord.new(date: date, male_count: male_count, female_count: female_count)
    daily_record.set_avg_ages
    daily_record.save!
  end
  
  def set_avg_ages(set_count = false)
    users = User.by_date(date)
    male_users = users.male
    female_users = users.female
    
    if set_count
      self.male_count = male_users.count
      self.female_count = female_users.count
      return unless self.male_count_changed? || self.female_count_changed?
    end
    self.male_avg_age = male_users.sum(:age) / male_users.count.to_f
    self.female_avg_age = female_users.sum(:age) / female_users.count.to_f
  end
end
