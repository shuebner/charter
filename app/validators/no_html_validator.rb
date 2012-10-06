include ApplicationHelper

class NoHtmlValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    unless value == (sanitize_paragraph_text value)
      record.errors[attribute] << (options[:message] || 'darf kein HTML enthalten')
    end
  end
end