# encoding: utf-8
include ApplicationHelper

class FirstNameValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    unless value.length >= 2 && value =~ /^[[:upper:]][[:alpha:] \-]+$/
      record.errors[attribute] << (options[:message] || 'ist kein gültiger Vorname')
    end
  end
end