# encoding: utf-8
class Customer < ActiveRecord::Base
  extend FriendlyId
  friendly_id :full_name, use: :slugged

  attr_accessible :city, :country, :gender, :email, :first_name, :last_name,
    :phone_landline, :phone_mobile, 
    :street_name, :street_number, :zip_code,
    :slug

  has_many :trip_bookings, foreign_key: :customer_number, primary_key: :number

  before_destroy :no_trip_bookings_exist

  validates :first_name,
    presence: true,
    length: { minimum: 2 },
    format: { with: /^[[:upper:]][[:alpha:] \-]+$/ }

  validates :last_name,
    presence: true,
    length: { minimum: 2 },
    format: { with: /^[[:alpha:] \-']+$/ }

  validates :gender,
    presence: true,
    inclusion: { in: ["m", "w"] }

  validates :phone_landline, :phone_mobile,
    allow_blank: true,
    format: { with: /^(\+\d{2,3})?\d+\-\d+$/ }

  validates :email,
    allow_blank: true,
    email_format: true

  validates :street_name,
    allow_blank: true,
    format: { with: /^[[:alnum:] \-\.']+$/ }

  validates :street_number,
    allow_blank: true,
    format: { with: /^\d+[a-zA-Z]?$/ }

  validates :zip_code,
    allow_blank: true,
    format: { with: /^(0[1-9]|[1-9]\d)\d{3}$/ }

  validates :city, :country,
    allow_blank: true,
    format: { with: /^[[:upper:]][[:alpha:] \-\.]+$/ }

  validates :number,
    presence: true,
    uniqueness: true

  scope :by_name, order("last_name ASC, first_name ASC")

  before_save { self.email = email.downcase unless email.blank? }

  def number
    unless self[:number]
      self[:number] = generate_number
    end
    self[:number]
  end

  def street
    "#{street_name} #{street_number}"
  end

  def full_name
    "#{first_name} #{last_name}"
  end

  def display_name
    "#{last_name}, #{first_name}"
  end

  private
  def no_trip_bookings_exist
    unless trip_bookings.empty?
      errors.add(:base, "Kunde kann nicht gelöscht werden, wenn bereits Törnbuchungen vorhanden sind")
      return false
    end
  end

  def generate_number
    last_customer = self.class.order("number DESC").first()
    if last_customer && !last_customer[:number].blank?
      last_customer.number.succ
    else
      31201
    end
  end
end
