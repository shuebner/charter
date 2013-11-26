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

  def current_period_start_at
    Setting.find_by_key(:current_period_start_at).value
  end

  def current_period_start_at=(date_string)
    Setting.find_by_key(:current_period_start_at).value = date_string
  end

  def current_period_end_at
    Setting.find_by_key(:current_period_end_at).value
  end

  def current_period_end_at=(date_string)
    Setting.find_by_key(:current_period_end_at).value = date_string
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