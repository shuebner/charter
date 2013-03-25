# encoding: utf-8
require 'spec_helper'

describe "CompositeTrips" do
  let!(:ctrip) { create(:composite_trip) }
  
  let!(:trip2) { create(:trip_for_composite_trip, composite_trip: ctrip) }
  let!(:date2) { create(:trip_date, trip: trip2,
    start_at: DateTime.new(2013, 6, 3, 10, 0, 0), 
    end_at: DateTime.new(2013, 6, 16, 12, 0, 0)) }
  
  let!(:trip1) { create(:trip_for_composite_trip, composite_trip: ctrip) }
  let!(:date1) { create(:trip_date, trip: trip1,
    start_at: DateTime.new(2013, 5, 26, 10, 0, 0), 
    end_at: DateTime.new(2013, 6, 2, 12, 0, 0)) }

  subject { page }

  describe "show page" do
    before { visit composite_trip_path(ctrip) }

    describe "with invalid parameters" do
      describe "when trip does not exist" do
        it "should raise a routing error" do
          expect do
            visit composite_trip_path('bla')
          end.to raise_error(ActionController::RoutingError)
        end
      end

      describe "when trip is not active" do
        before do
          ctrip.deactivate!
          ctrip.save!
        end
        it "should raise a routing error" do
          expect do
            visit composite_trip_path(ctrip)
          end.to raise_error(ActionController::RoutingError)
        end
      end
    end

    describe "legs" do
      it "should be shown in ascending order by start_at of their trip date" do
        within "#content ul.leg-list" do
          page.should have_selector("li:nth-child(1)", text: trip1.name)
          page.should have_selector("li:nth-child(2)", text: trip2.name)
        end
      end
    end

    describe "information" do
      describe "about the composite trip" do
        [:name, :description].each do |a|
          it "should include the #{a.to_s}" do
            within("#content") { page.should have_content(ctrip.send(a)) }
          end
        end
        it "should include the boat" do
          within("#content") { page.should have_content(ctrip.boat.name) }
        end
      end

      describe "about the legs" do
        describe "when inactive" do
          let(:inactive_leg) { ctrip.trips.first }
          before do
            inactive_leg.deactivate!
            inactive_leg.save!
            visit composite_trip_path(ctrip)
          end
          
          it "should not be shown" do
            within("#content") { page.should_not have_content(inactive_leg.name) }
          end
        end

        describe "when active" do
          describe "basics" do
            [:name, :description].each do |a|
              it "should include the #{a.to_s}" do
                within("#content") { page.should have_content(trip1.send(a)) }
              end
            end
          end
          describe "trip dates" do
            it "should include start and end" do
              within("ul.leg-list li:nth-child(1) table") do
                page.should have_selector("td.start-at", text: I18n.l(date1.start_at))
                page.should have_selector("td.end-at", text: I18n.l(date1.end_at))
              end
            end

            describe "number of available bunks" do
              it "should be the correct number" do
                within("ul.leg-list li:nth-child(1) table") do
                  page.should have_selector("td.available-bunks", text: "#{date1.no_of_available_bunks}")
                end
              end
              describe "when trip date is deferred" do
                before do
                  date1.defer!
                  date1.save!
                  visit composite_trip_path(ctrip)
                end
                
                it "should show as zero" do
                  within("ul.leg-list li:nth-child(1) table") do
                    page.should have_selector("td.available-bunks", text: "0")
                  end                  
                end
              end
            end
          end
        end
      end
    end
 
    describe "links to trip inquiries" do
      it "should have a link to the right trip inquiry form" do
        page.should have_link("buchen", href: new_trip_inquiry_path(trip_date_id: date1.id))
      end

      describe "when trip date is full" do
        let!(:trip_booking) { create(:trip_booking, trip_date: date1, 
          no_of_bunks: date1.no_of_available_bunks) }
        before { visit composite_trip_path(ctrip) }

        it "should not have a link to an inquiry" do
          page.should_not have_link("buchen", href: new_trip_inquiry_path(trip_date_id: date1.id))
        end
      end

      describe "when trip date is deferred" do
        before do
          date1.defer!
          date1.save!
          visit composite_trip_path(ctrip)
        end
        it "should not have a link to an inquiry" do
          page.should_not have_link("buchen", href: new_trip_inquiry_path(trip_date_id: date1.id))
        end
      end
    end
  end
end