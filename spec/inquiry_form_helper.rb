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
end