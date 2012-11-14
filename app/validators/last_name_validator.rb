# encoding: utf-8
include ApplicationHelper

class LastNameValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    unless value.length >= 2 && value =~ /^[[:alpha:] \-']+$/
      record.errors[attribute] << (options[:message] || 'ist kein gültiger Nachname')
    end
  end
end