class User < ApplicationRecord
  include HTTParty

  validates_uniqueness_of :uuid

  scope :by_date,    -> (date) { where("created_at between (?) and (?)", date.beginning_of_month, date.end_of_day) }
  scope :female,        lambda { where(gender: "female") }
  scope :male,          lambda { where(gender: "male") }
  scope :filter_by_name,  -> (name) { where("name ->> 'first' ILIKE ? OR name ->> 'last' ILIKE ?", "%#{name}%", "%#{name}%") }
  
  after_destroy :update_daily_record
  
  def full_name
    "#{name['title']} #{name['first']} #{name['last']}"
  end

  def self.import_users
    base_uri = ENV['user_import_url'] # 'https://randomuser.me/api/?results=20'
    response = HTTParty.get(base_uri)

    user_ids = []
    users_data = JSON.parse(response.body)["results"]
    users_data.each do |user_row|
      user = User.find_or_initialize_by(uuid: user_row["login"]["uuid"])
      user.name = user_row["name"]
      user.gender = user_row["gender"]
      user.location = user_row["location"]
      user.age = user_row["dob"]["age"]
      user.save!
      user_ids << user.id
    end
    users = User.where(id: user_ids.uniq)
    female_count = users.female.count
    male_count = users.male.count
    user_count = {male_count: male_count, female_count: female_count}
    return user_count
  end

  def update_daily_record
    daily_record = DailyRecord.where(date: self.created_at.to_date).first
    if daily_record.present?
      daily_record.set_avg_ages(true)
      daily_record.save!
    end
  end

end
