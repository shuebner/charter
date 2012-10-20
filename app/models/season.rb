# encoding: utf-8
class Season < ActiveRecord::Base
  attr_accessible :begin_date, :end_date, :name

  validates :name,
    presence: true

  validates :begin_date,
    presence: true,
    timeliness: { type: :date }

  validates :end_date,
    presence: true,
    timeliness: { type: :date, after: :begin_date }

  validate :no_overlap

  before_save { self.name = sanitize(name, tags: []) }

  def self.overlapping(season)
    if season.id
      where("DATEDIFF(begin_date, :end_date) * DATEDIFF(:begin_date, end_date) >= 0", 
        { begin_date: season.begin_date, end_date: season.end_date }).
        where("NOT id = ?", season.id)
    else
      where("DATEDIFF(begin_date, :end_date) * DATEDIFF(:begin_date, end_date) >= 0", 
        { begin_date: season.begin_date, end_date: season.end_date })
    end  
  end

  private

  def no_overlap
    unless Season.overlapping(self).empty?
      error_text = "Saison überschneidet sich mit "
      Season.overlapping(self).each do |s|
        error_text << "#{s.name} (#{I18n.l(s.begin_date)} - #{I18n.l(s.end_date)}) "
      end
      errors.add(:begin_date, error_text)
      errors.add(:end_date, error_text)
    end
  end
end
