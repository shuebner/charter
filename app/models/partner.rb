# encoding: utf-8

class Partner < ActiveRecord::Base
  attr_accessible :name, :order, :url, :image_attributes

  has_one :image, as: :attachable, class_name: "PartnerImage",
    dependent: :destroy
  accepts_nested_attributes_for :image, allow_destroy: true

  validates :name,
    presence: true

  validates :url,
    presence: true,
    format: { with: URI::regexp(%w(http https)),
      message: "kein gültiges URL-Format" }

  validates :order,
    presence: true,
    numericality: { only_integer: true }

  default_scope includes(:image).order("partners.order ASC")
end
