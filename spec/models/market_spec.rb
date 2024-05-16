require "rails_helper"

RSpec.describe Market, type: :model do
  describe "validations" do
    it { should validate_presence_of :name }
    it { should validate_presence_of :street }
    it { should validate_presence_of :city }
    it { should validate_presence_of :county }
    it { should validate_presence_of :state }
    it { should validate_presence_of :zip }
    it { should validate_presence_of :lat }
    it { should validate_presence_of :lon }
  end

  describe "relationships" do
    it { should have_many :market_vendors }
    it { should have_many(:vendors).through(:market_vendors) }
  end

  describe "class methods" do
    before(:each) do
      @market1 = Market.create!(
        name: "Denver Market",
        street: Faker::Address.street_address,
        city: "Denver",
        county: "Denver County",
        state: "CO",
        zip: "80301",
        lat: "37.740092",
        lon: "-104.990308"
      )

      @market2 = Market.create!(
        name: "Atlanta Market",
        street: Faker::Address.street_address,
        city: "Atlanta",
        county: "Atlanta County",
        state: "GA",
        zip: "30312",
        lat: "33.744292",
        lon: "-84.375925"
      )

      @market3 = Market.create!(
        name: "Colorado Springs Market",
        street: Faker::Address.street_address,
        city: "Colorado Springs",
        county: "El Paso County",
        state: "CO",
        zip: "80904",
        lat: "38.740092",
        lon: "-105.990308"
      )
    end

    it "can search by any valid combination of city, state, and name" do
      params1 = {
        name: "denver",
        state: "co",
        city: "den"
      }

      params2 = {
        state: "co",
        city: "den"
      }

      params3 = {
        state: "co"
      }

      params4 = {
        name: "denver",
        state: "co"
      }

      params5 = {
        name: "denver"
      }

      expect(Market.search(params1)[0]).to eq(@market1)
      expect(Market.search(params2)[0]).to eq(@market1)
      expect(Market.search(params3)[0]).to eq(@market1)
      expect(Market.search(params4)[0]).to eq(@market1)
      expect(Market.search(params5)[0]).to eq(@market1)
    end
  end
end
