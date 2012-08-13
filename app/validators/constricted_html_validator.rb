include ApplicationHelper

class ConstrictedHtmlValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    unless value == (sanitize_page_text value)
      record.errors[attribute] << (options[:message] || 'is not valid constricted HTML')
    end
  end
end