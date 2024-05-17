require "rails_helper"

RSpec.describe "market atms" do
  before(:each) do
    @market  = create(:market, lat: 36.98844, lon: -121.97483)
    @headers = {
      CONTENT_TYPE: "application/json",
      ACCEPT: "application/json"
    }
  end

  describe "happy paths" do
    VCR.use_cassette("can_find_the_nearest_atms.yml") do
      it "can find the nearest atms", :vcr do
        get nearest_atms_api_v0_market_path(@market), headers: @headers

        expect(response).to be_successful
        expect(response.status).to eq(200)

        atms = JSON.parse(response.body, symbolize_names: true)[:data]
        atm = atms.first
        expect(atm[:type]).to eq("atm")

        attrs = atm[:attributes]

        check_hash_structure(attrs, :name, String)
        check_hash_structure(attrs, :address, String)
        check_hash_structure(attrs, :lat, Float)
        check_hash_structure(attrs, :lon, Float)
        check_hash_structure(attrs, :distance, Float)
      end
    end
  end

  describe "sad path" do
    it "returns the correct error code", :vcr do
      get nearest_atms_api_v0_market_path(123_123_123), headers: @headers

      expect(response).to_not be_successful
      expect(response.status).to eq(404)

      data = JSON.parse(response.body, symbolize_names: true)

      expect(data[:errors]).to be_a(Array)
      expect(data[:errors].first[:detail]).to eq("Couldn't find Market with 'id'=123123123")
    end
  end
end
