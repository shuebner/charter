# encoding: utf-8
include ApplicationHelper

class PhoneNumberValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    unless value =~ /^(\+\d{2,3})?\d+\-\d+$/
      record.errors[attribute] << (options[:message] || 'ist keine gültige Telefonnummer')
    end
  end
end