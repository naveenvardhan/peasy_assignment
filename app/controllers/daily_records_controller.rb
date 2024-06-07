class DailyRecordsController < ApplicationController
  
  def index
    @daily_records = DailyRecord.all
    @total_male_count = @daily_records.sum(:male_count)
    @total_female_count = @daily_records.sum(:female_count)
  end

end
