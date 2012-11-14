class Captain < ActiveRecord::Base
  extend FriendlyId
  friendly_id :full_name, use: :slugged

  attr_accessible :additional_certificates, :description, :email, 
    :first_name, :last_name, :phone, :sailing_certificates

  validates :first_name,
    presence: true,
    first_name: { allow_blank: true }

  validates :last_name,
    presence: true,
    last_name: { allow_blank: true }

  validates :phone,
    presence: true,
    phone_number: { allow_blank: true }

  validates :email,
    allow_blank: true,
    email_format: true

  before_save { self.email = email.downcase unless email.blank? }

  def full_name
    "#{first_name} #{last_name}"
  end
end
