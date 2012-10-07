class Customer < ActiveRecord::Base
  attr_accessible :city, :email, :first_name, :gender, :last_name, :phone_landline, :phone_mobile, :street_name, :street_number, :zip_code
end
