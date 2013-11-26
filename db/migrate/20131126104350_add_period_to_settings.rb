class AddPeriodToSettings < ActiveRecord::Migration
  def change
    unless Setting.find_by_key('current_period_start_at')
      Setting.create(key: 'current_period_start_at', value: "01.01.2014")
    end
    unless Setting.find_by_key('current_period_end_at')
      Setting.create(key: 'current_period_end_at', value: "31.12.2014")
    end
  end  
end
