require 'rails_helper'

RSpec.describe 'market show' do
  before(:each) do
    @market = FactoryBot.create(:market)
  end

  describe 'happy paths' do
    # VCR.use_cassette('fixture name')
      it 'can return market by id', :vcr do
        headers = { 'CONTENT_TYPE': 'application/json', 'ACCEPT': 'application/json' }

        get "/api/v0/markets/#{@market.id}", headers: headers

        expect(response).to be_successful
        expect(response.status).to eq(200)

        market = JSON.parse(response.body, symbolize_names: true)[:data]

        check_hash_structure(market, :id, String)
        expect(market[:type]).to eq('market')

        attrs = market[:attributes]

        check_hash_structure(attrs, :name, String)
        check_hash_structure(attrs, :street, String)
        check_hash_structure(attrs, :city, String)
        check_hash_structure(attrs, :county, String)
        check_hash_structure(attrs, :state, String)
        check_hash_structure(attrs, :zip, String)
        check_hash_structure(attrs, :lat, String)
        check_hash_structure(attrs, :lon, String)
      end
  # end
  end

  describe 'sad path' do
    it 'returns a descriptive error' do
      get "/api/v0/markets/10000", headers: headers

      expect(response).to_not be_successful
      expect(response.status).to eq(404)

      data = JSON.parse(response.body, symbolize_names: true)
      
      expect(data[:errors]).to be_a(Array)
      expect(data[:errors].first[:detail]).to eq("Couldn't find Market with 'id'=10000")
    end
  end
end