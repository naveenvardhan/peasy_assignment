class User < ApplicationRecord
  include HTTParty

  
  def self.import_users
    base_uri = 'https://randomuser.me/api/?results=20'
    response = HTTParty.get(base_uri)

    users_data = JSON.parse(response.body)["results"]
    users_data.each do |user_row|
      user = User.find_or_initialize_by(uuid: user_row["login"]["uuid"])
      user.name = user_row["name"]
      user.gender = user_row["gender"]
      user.location = user_row["location"]
      user.age = user_row["dob"]["age"]
      user.save!
    end
  end

  def self.create_records
    # Tabulate the total number of male and female records capture within the day from Redis
    # Store the said total into the DailyRecord table
    # Using ActiveRecord:Dirty, code your DailyRecord model object so that whenever male_count and female_count attribute is changed, your code will calculate the average age of all male and female records in the User table and store into the male_avg_age and female_avg_age attribute.
  end

end
