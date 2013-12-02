# encoding: utf-8
class Setting < ActiveRecord::Base

  attr_accessible :value
  attr_readonly :key

  validates :key, :value,
    presence: true

  validate :value_is_valid_date?, if: :date_setting?

  before_destroy { 
    errors.add(:base, "Einstellungen können nicht gelöscht werden.")
    false
  }

  DF_CURRENT_PERIOD_START_AT = Date.new(2014, 1, 1)
  DF_CURRENT_PERIOD_END_AT = Date.new(2014, 12, 31)

  def self.current_period_start_at
    setting = Setting.find_by_key('current_period_start_at')
    value = setting ? setting.value : I18n.l(DF_CURRENT_PERIOD_START_AT)
    Date.strptime(value, I18n.t('date.formats.default'))
  end

  def self.current_period_start_at=(date)
    setting = Setting.find_by_key('current_period_start_at')
    unless setting
      setting = Setting.new
      setting.key = 'current_period_start_at'
    end
    setting.value = I18n.l(date)
    setting.save
  end

  def self.current_period_end_at
    setting = Setting.find_by_key('current_period_end_at')
    value = setting ? setting.value : I18n.l(DF_CURRENT_PERIOD_END_AT)
    Date.strptime(value, I18n.t('date.formats.default'))
  end

  def self.current_period_end_at=(date)
    setting = Setting.find_by_key('current_period_end_at')
    unless setting
      setting = Setting.new
      setting.key = 'current_period_end_at'
    end
    setting.value = I18n.l(date)
    setting.save
  end


  private

  def date_setting?
    ["current_period_start_at", "current_period_end_at"].include? key
  end

  def value_is_valid_date?
    begin
      date = Date.strptime(value, I18n.t('date.formats.default'))
    rescue
      errors.add(:value, "ist kein gültiges Datum")
      return false
    end
    unless Date.valid_date? date.year, date.month, date.day
      errors.add(:value, "ist kein gültiges Datum")
    end    
  end
end