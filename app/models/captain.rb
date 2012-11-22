class Captain < ActiveRecord::Base
  extend FriendlyId
  friendly_id :full_name, use: :slugged

  attr_accessible :additional_certificates, :description, :email, 
    :first_name, :last_name, :phone_mobile, :sailing_certificates

  has_one :image, as: :attachable, class_name: "CaptainImage",
    dependent: :destroy
  accepts_nested_attributes_for :image, allow_destroy: true
  attr_accessible :image_attributes

  validates :first_name,
    presence: true,
    first_name: { allow_blank: true }

  validates :last_name,
    presence: true,
    last_name: { allow_blank: true }

  validates :phone_mobile,
    presence: true,
    phone_number: { allow_blank: true }

  validates :email,
    allow_blank: true,
    email_format: true

  before_save { self.email = email.downcase unless email.blank? }

  def full_name
    "#{first_name} #{last_name}"
  end

  def sailing_certificates_array
    sailing_certificates.split(';').each(&:strip!)
  end

  def additional_certificates_array
    additional_certificates.split(';').each(&:strip!)
  end
end
