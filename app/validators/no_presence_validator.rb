# encoding: utf-8
include ApplicationHelper

class NoPresenceValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    unless value.blank?
      record.errors[attribute] << (options[:message] || 'darf nicht ausgefüllt sein')
    end
  end
end