# encoding: utf-8

require 'spec_helper'

describe Boat do
  let(:boat) { build(:boat) }

  subject { boat }

  it { should respond_to(:manufacturer) }
  it { should respond_to(:model) }
  it { should respond_to(:length_hull) }
  it { should respond_to(:length_waterline) }
  it { should respond_to(:beam) }
  it { should respond_to(:draft) }
  it { should respond_to(:air_draft) }
  it { should respond_to(:displacement) }
  it { should respond_to(:sail_area_jib) }
  it { should respond_to(:sail_area_genoa) }
  it { should respond_to(:sail_area_main_sail) }
  it { should respond_to(:tank_volume_diesel) }
  it { should respond_to(:tank_volume_fresh_water) }
  it { should respond_to(:tank_volume_waste_water) }
  it { should respond_to(:permanent_bunks) }
  it { should respond_to(:convertible_bunks) }
  it { should respond_to(:max_no_of_people) }
  it { should respond_to(:recommended_no_of_people) }
  it { should respond_to(:headroom_saloon) }
  it { should respond_to(:name) }
  it { should respond_to(:slug) }
  it { should respond_to(:year_of_construction) }
  it { should respond_to(:year_of_refit) }
  it { should respond_to(:engine_model) }
  it { should respond_to(:engine_output) }
  it { should respond_to(:battery_capacity) }
  it { should respond_to(:available_for_boat_charter) }
  it { should respond_to(:available_for_bunk_charter) }
  it { should respond_to(:deposit) }
  it { should respond_to(:cleaning_charge) }
  it { should respond_to(:fuel_charge) }
  it { should respond_to(:gas_charge) }

  it { should respond_to(:active) }

  it { should respond_to(:owner) }
  it { should respond_to(:port) }

  it { should be_valid }
  
  describe "when manufacturer is not present" do
    before { boat.manufacturer = nil }
    it { should_not be_valid }
  end

  describe "when model is not present" do
    before { boat.model = nil }
    it { should_not be_valid }
  end

  describe "when name is empty" do
    before { boat.name = nil }
    it { should_not be_valid }
  end

  describe "when slug is empty" do
    let!(:boat_without_slug) do 
      build(:boat, name: "Testschiff Bla 2", slug: nil)
    end

    subject { boat_without_slug }

    describe "upon saving the slug should be automatically added" do
      before { boat_without_slug.save! }
      it { should be_valid }
      its(:slug) { should == "testschiff-bla-2" }    
    end
  end

  describe "when available_for_boat_charter is empty" do
    before { boat.available_for_boat_charter = nil }
    it { should_not be_valid }
  end

  describe "when available_for_bunk_charter" do
    describe "is empty" do
      before { boat.available_for_bunk_charter = nil}
      it { should_not be_valid }
    end
    describe "is set to false with trips associated to the boat" do
      before do
        boat.save
        create(:trip, boat: boat)
        boat.available_for_bunk_charter = false
      end
      it { should_not be_valid }
    end
  end

  describe "when numerical field" do
    [:length_hull, :length_waterline, :beam, :draft, :air_draft, :displacement, 
    :sail_area_jib, :sail_area_genoa, :sail_area_main_sail, 
    :tank_volume_diesel, :tank_volume_fresh_water, :tank_volume_waste_water, 
    :permanent_bunks, :convertible_bunks, 
    :max_no_of_people, :recommended_no_of_people, 
    :headroom_saloon, :year_of_construction, :year_of_refit, :engine_output,
    :deposit, :cleaning_charge, :fuel_charge, :gas_charge].each do |a|
      describe "#{a} is not a number" do
        before { boat[a] = "20a" }
        it { should_not be_valid }
      end
      describe "#{a} is not positive or zero" do
        before { boat[a] = -1 }
        it { should_not be_valid }
      end
    end

    describe "of type integer" do
      [:tank_volume_diesel, :tank_volume_fresh_water, :tank_volume_waste_water, 
      :permanent_bunks, :convertible_bunks, 
      :max_no_of_people, :recommended_no_of_people, 
      :year_of_construction, :year_of_refit, :engine_output].each do |a|
        describe "#{a} is not an integer" do
          before { boat[a] = 2.5 }
          it { should_not be_valid }
        end
      end
    end
  end

  describe "when text field" do
    [:manufacturer, :model, :name, :engine_model].each do |a|
      describe "#{a} contains HTML" do
        before { boat[a] = "<p>Hallo</p>" }
        it "should be sanitized on save" do
          boat.save
          boat[a].should == "Hallo"
        end
      end
    end
  end

  describe "when owner is not present" do
    before { boat.owner = nil }
    it { should_not be_valid }
  end

  describe "when port is not present" do
    before { boat.port = nil }
    it { should_not be_valid }
  end

  describe "activation" do
    let(:default_boat) { Boat.new }
    subject { default_boat }
    
    describe "active" do
      it "should be false by default" do      
        default_boat.should_not be_active
      end
    end
    
    describe "after activation by activate!" do
      before { default_boat.activate! }
      it { should be_active }

      describe "followed by deactivation by deactivate!" do
        before { default_boat.deactivate! }
        it { should_not be_active }
      end
    end
  end

  describe "calculated field" do
    
    describe "sail area fields" do
      before { boat.sail_area_main_sail = 10 }
      
      describe "with all necessary areas given" do
        before do 
          boat.sail_area_jib = 1
          boat.sail_area_genoa = 3
        end
        its(:total_sail_area_with_jib) { should == 11 }        
        its(:total_sail_area_with_genoa) { should == 13 }
      end
      describe "without all necessay areas given" do
        before do 
          boat.sail_area_jib = nil
          boat.sail_area_genoa = nil
        end
        it "should not raise an error" do
          lambda { boat.total_sail_area_with_jib }.should_not raise_error          
          lambda { boat.total_sail_area_with_genoa }.should_not raise_error
        end          
        its(:total_sail_area_with_jib) { should be_nil }
        its(:total_sail_area_with_genoa) { should be_nil }
      end
    end
    
    describe "visible?" do
      describe "should be true if boat is available for boat charter" do
        before do
          boat.available_for_boat_charter = true
          boat.available_for_bunk_charter = false
        end
        it { should be_visible }
      end
      describe "should be true if boat is available for bunk charter" do
        before do
          boat.available_for_boat_charter = false
          boat.available_for_bunk_charter = true
        end
        it { should be_visible }
      end
      describe "should be false if boat is available for NEITHER boat NOR bunk charter" do
        before do
          boat.available_for_bunk_charter = false
          boat.available_for_boat_charter = false
        end
        it { should_not be_visible }
      end
    end

    describe "max_no_of_bunks should be sum of permanent and convertible bunks" do
      before do
        boat.permanent_bunks = 4
        boat.convertible_bunks = 2
      end
      its(:max_no_of_bunks) { should == 6 }
    end

    describe "prices" do
      before do
        2.times { create(:season) }
        2.times { create(:boat_price_type) }
        Season.all.each do |s|
          BoatPriceType.all.each do |t|
            create(:boat_price, boat: boat, season: s, boat_price_type: t)
          end
        end
      end
      it "should return the boat price for a season and boat price type" do
        Season.all.each do |s|
          BoatPriceType.all.each do |t|
            right_price = BoatPrice.where(season_id: s.id, 
              boat_price_type_id: t.id, boat_id: boat.id).first
            boat.prices(s, t).should == right_price
          end
        end
      end
    end

    describe "display_name" do
      before do
        boat.name = "Zora"
        boat.model = "Sunbeam 25"
      end
      its(:display_name) { should == "Sunbeam 25 (Zora)" }
    end
  end

  describe "availability methods" do    
    let!(:trip_date) do
      create(:trip_date, 
        begin_date: 1.day.from_now, end_date: 5.days.from_now)
    end

    let(:trip) { trip_date.trip }
    let(:boat) { trip.boat }

    let!(:boat_booking) do
      create(:boat_booking, boat: boat,
        begin_date: 10.days.from_now, end_date: 14.days.from_now)
    end
    
    describe "when reservation" do
      
      describe "does not overlap with trip dates or boat bookings" do
        let!(:reservation) do
          build(:trip_date, trip: trip, 
            begin_date: trip_date.end_date + 1.minute, end_date: boat_booking.begin_date - 1.minute)
        end
        it "available_for_reservation? should return true" do
          boat.should be_available_for_reservation(reservation)
        end
        it "overlapping_reservations should return empty lists" do
          overlap = boat.overlapping_reservations(reservation)
          overlap[:trip_dates].should be_empty
          overlap[:boat_bookings].should be_empty
        end

        describe "after saving the new reservation" do
          before { reservation.save! }
          it "available_for_reservation? should still return true" do
            boat.should be_available_for_reservation(reservation)
          end
          it "overlapping_reservations should still return empty lists" do
            overlap = boat.overlapping_reservations(reservation)
            overlap[:trip_dates].should be_empty
            overlap[:boat_bookings].should be_empty
          end          
        end
      end
      
      describe "overlaps with trip dates" do
        let!(:reservation) do
          build(:trip_date, trip: trip, 
            begin_date: trip_date.end_date - 1.minute, end_date: boat_booking.begin_date - 1.minute)
        end            
        it "available_for_reservation? should return false" do
          boat.should_not be_available_for_reservation(reservation)
        end
        it "overlapping_reservations should return a list with the overlapping trip dates" do
          boat.overlapping_reservations(reservation).should == 
            { trip_dates: [trip_date], boat_bookings: [] }
        end
      end

      describe "overlaps with boat bookings" do
        let!(:reservation) do
          build(:trip_date, trip: trip,
            begin_date: trip_date.end_date + 1.minute, end_date: boat_booking.begin_date + 1.minute)
        end
        it "available_for_reservation? should return false" do
          boat.should_not be_available_for_reservation(reservation)
        end
        it "overlapping_reservations should return a list with the overlapping boat bookings" do
          boat.overlapping_reservations(reservation).should ==
            { trip_dates: [], boat_bookings: [boat_booking] }
        end
      end
    end
  end

  describe "scope" do
    describe "visible" do
      let(:active_available_boat1) { create(:boat) }
      let(:active_available_boat2) { create(:bunk_charter_only_boat) }
      let(:active_available_boat3) { create(:boat_charter_only_boat) }
      let(:active_unavailable_boat) { create(:unavailable_boat) }
      let(:inactive_available_boat) { create(:boat, active: false) }
      
      it "should contain all available and active boats" do
        Boat.visible.should include(active_available_boat1, active_available_boat2,
          active_available_boat3)        
      end
      it "should not contain any unavailable or inactive boats" do
        Boat.visible.should_not include(active_unavailable_boat, inactive_available_boat)
      end
    end

    describe "bunk and boat charter only" do
      let(:boat_for_bunk_charter_only) { create(:bunk_charter_only_boat) }
      let(:boat_for_boat_charter_only) { create(:boat_charter_only_boat) }
      describe "bunk_charter_only" do
        it "should contain all boats available for bunk charter" do
          Boat.bunk_charter_only.should include(boat_for_bunk_charter_only)
        end
        it "should not contain any boat not available for bunk charter" do
          Boat.bunk_charter_only.should_not include(boat_for_boat_charter_only)
        end
      end
      describe "boat_charter_only" do
        it "should contain all boats available for boat charter" do
          Boat.boat_charter_only.should include(boat_for_boat_charter_only)
        end
        it "should not contain any boat not available for boat charter" do
          Boat.boat_charter_only.should_not include(boat_for_bunk_charter_only)
        end
      end
    end
  end

  describe "default sort order" do
    let!(:second_boat) { create(:boat, model: "ZZZ") }
    let!(:first_boat) { create(:boat, model: "AAA") }
    
    it "should sort ascending by model" do
      Boat.all.should == [first_boat, second_boat]
    end
  end

  describe "association with trip" do
    describe "with boat available for bunk charter" do
      let!(:boat_for_bunk_charter) { create(:boat, available_for_bunk_charter: true) }
      let!(:second_trip) { create(:trip, name: "Z-Törn", boat: boat_for_bunk_charter) }
      let!(:first_trip) { create(:trip, name: "A-Törn", boat: boat_for_bunk_charter) }

      subject { boat_for_bunk_charter }
      
      it "should have the right trips in the right order" do
        boat_for_bunk_charter.trips.should == [first_trip, second_trip]
      end

      it "should destroy associated trips" do
        trips = boat_for_bunk_charter.trips
        boat_for_bunk_charter.destroy
        trips.each do |trip|
          lambda do
            Trip.find(trip.id)
          end.should raise_error(ActiveRecord::RecordNotFound)
        end
      end
    end
  end

  describe "association with boat booking" do
    let!(:boat_booking2) { create(:boat_booking, boat: boat) }
    let!(:boat_booking1) do
      create(:boat_booking, boat: boat,
        begin_date: boat_booking2.begin_date - 10.days,
        end_date: boat_booking2.begin_date - 3.days)
    end
    
    it "should have the right boat bookings in the right order" do
      boat.boat_bookings.should == [boat_booking1, boat_booking2]
    end

    describe "destruction of boat" do
      describe "with boat bookings present" do
        it "should not be possible" do
          expect { boat.destroy }.not_to change(Boat, :count)
        end
      end
      describe "without boat bookings present" do
        before do
          boat_booking1.destroy
          boat_booking2.destroy
        end
        it "should be possible" do
          expect { boat.destroy }.to change(Boat, :count).by(-1)
        end
      end
    end
  end

  describe "association with boat price" do
    let!(:price) { create(:boat_price, boat: boat) }
    its(:boat_prices) { should == [price] }

    it "should delete associated boat prices" do
      expect { boat.destroy }.to change(BoatPrice, :count).by(-1)
    end
  end

  describe "association with images" do
    before { boat.save }
    let!(:boat_image2) { create(:boat_image, attachable: boat, order: 2) }
    let!(:boat_image1) { create(:boat_image, attachable: boat, order: 1) }

    it "should have the right images in the right order" do
      boat.images.should == [boat_image1, boat_image2]
    end

    it "should delete associated images" do
      expect { boat.destroy }.to change(BoatImage, :count).by(-2)
    end

    describe "title_image" do
      describe "if there is at least one image" do
        it "should return the first image of the boat" do
          boat.title_image.should == boat_image1
        end
      end
      describe "if there are no images" do
        before { boat.images.destroy_all }
        it "should not raise an error and return nil" do
          boat.title_image.should be_nil
        end
      end
    end

    describe "other_images" do
      describe "if there is at least one other than the title image" do
        it "should return all the images except the title image" do
          boat.other_images.should == [boat_image2]
        end
      end
      describe "if there are no images except the title image" do
        before { boat.images.destroy(boat_image2) }
        it "should return an empty array" do
          boat.other_images.should == []
        end
      end
    end
  end

  describe "association with documents" do
    before { boat.save }
    let!(:boat_doc2) { create(:document, attachable: boat, order: 2) }
    let!(:boat_doc1) { create(:document, attachable: boat, order: 1) }
    
    it "should have the right documents in the right order" do
      boat.documents.should == [boat_doc1, boat_doc2]
    end

    it "should delete associated documents" do
      expect { boat.destroy }.to change(Document, :count).by(-2)
    end
  end

  describe "association with boat owner" do
    let(:owner) { build(:boat_owner) }
    before { boat.owner = owner }
    its(:owner) { should == owner }
  end
end
