# encoding: utf-8
require 'spec_helper'

describe CalendarSpecHelper do
  describe "months_between" do
    date1 = Date.new(2013, 11, 11)
    date2 = Date.new(2014, 2, 6)
    it "should include all localized month names with corresponding year" do
      months_between(date1, date2).should ==
        ["November 2013", "Dezember 2013", "Januar 2014", "Februar 2014"]
    end
  end
end