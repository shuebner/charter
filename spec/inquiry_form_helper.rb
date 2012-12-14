# encoding: utf-8
module InquiryFormHelper

  def fill_in_and_submit_form(additional_form_actions)
    fill_in_form(additional_form_actions)
    submit_form
  end

  def fill_in_form(additional_form_actions)
    default_form_fields = 
      { 'Vorname' => 'Hans',
        'Nachname' => 'Müller',
        'E-Mail-Adresse' => 'HansMueller@beispiel.de',
        'Nachricht' => 'Ich will segeln!' }
    
    default_form_fields.each { |field, value| fill_in field, with: value }
    
    if additional_form_actions
      additional_form_actions.call(page)
    end
  end

  def submit_form
    click_button 'Absenden'
  end

  def select_date(page, date, options = {})  
    raise ArgumentError, 'from is a required option' if options[:from].blank?
    field = options[:from].to_s
    page.select date.year.to_s,               :from => "#{field}_1i"
    page.select Date::MONTHNAMES[date.month], :from => "#{field}_2i"
    page.select date.day.to_s,                :from => "#{field}_3i"
  end  
end