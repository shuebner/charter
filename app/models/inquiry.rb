# encoding: utf-8
class Inquiry < ActiveRecord::Base
  acts_as_citier
  attr_accessible :email, :first_name, :last_name, :text

  validates :first_name,
    presence: true,
    first_name: { allow_blank: true }

  validates :last_name,
    presence: true,
    last_name: { allow_blank: true }

  validates :email,
    presence: true,
    email_format: { message: 'ist keine gültige E-Mail-Adresse' }

  before_save :sanitize_text, :standardize_email

  private

  def sanitize_text
    self.text = sanitize(text, tags: [])
  end

  def standardize_email
    self.email = email.downcase unless email.blank?
  end
end
