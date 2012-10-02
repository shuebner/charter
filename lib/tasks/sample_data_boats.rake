# encoding: utf-8
namespace :db do 
  desc "create sample data for boats"  
  task boats: :environment do
    require 'factory_girl'
    require File.dirname(__FILE__) + '/../../spec/factories.rb'
    5.times { FactoryGirl.create(:boat) }
  end
end