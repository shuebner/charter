class AddPeriodToSettingsDirectly < ActiveRecord::Migration
  def change
    unless Setting.find_by_key('current_period_start_at')
      Setting.connection.execute("INSERT INTO settings (settings.key, settings.value) VALUES('current_period_start_at', '01.03.2014');")
    end
    unless Setting.find_by_key('current_period_end_at')
      Setting.connection.execute("INSERT INTO settings (settings.key, settings.value) VALUES('current_period_end_at', '31.10.2014');")
    end    
  end
end
