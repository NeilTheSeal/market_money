require "rails_helper"

RSpec.describe "make requests for all vendors in a market" do
  before(:each) do
    @market = create(:market)
    @market2 = create(:market)

    @vendors = create_list(:vendor, 3)

    @market2_vendors = create_list(:vendor, 3)

    @vendors.each do |vendor|
      MarketVendor.create!(
        market: @market,
        vendor:
      )
    end

    @market2_vendors.each do |vendor|
      MarketVendor.create!(
        market: @market2,
        vendor:
      )
    end
  end

  it "returns all vendors for a market as json" do
    get "/api/v0/markets/#{@market.id}/vendors"

    expect(response).to be_successful

    body = JSON.parse(response.body, symbolize_names: true)

    expect(body).to have_key(:data)

    data = body[:data]

    expect(data.count).to eq(3)

    data.each do |vendor|
      expect(vendor).to have_key(:id)
      expect(vendor[:id]).to be_a(String)

      expect(vendor).to have_key(:type)
      expect(vendor[:type]).to be_a(String)

      expect(vendor).to have_key(:attributes)
      expect(vendor[:attributes]).to be_a(Hash)

      expect(vendor[:attributes]).to have_key(:name)
      expect(vendor[:attributes][:name]).to be_a(String)

      expect(vendor[:attributes]).to have_key(:description)
      expect(vendor[:attributes][:description]).to be_a(String)

      expect(vendor[:attributes]).to have_key(:contact_name)
      expect(vendor[:attributes][:contact_name]).to be_a(String)

      expect(vendor[:attributes]).to have_key(:contact_phone)
      expect(vendor[:attributes][:contact_phone]).to be_a(String)

      expect(vendor[:attributes]).to have_key(:credit_accepted)
      expect(vendor[:attributes][:credit_accepted]).to eq(true).or eq(false)
    end

    expect(data[0][:attributes][:name]).to eq(@vendors[0].name)
  end

  it "returns a 404 with an error if an invalid market id is given" do
    get "/api/v0/markets/2352385923058/vendors"

    expect(response).to have_http_status(404)

    body = JSON.parse(response.body, symbolize_names: true)

    expect(body).to have_key(:errors)

    errors = body[:errors]
    expect(errors).to be_an(Array)

    expect(errors[0]).to be_a(Hash)
    expect(errors[0]).to have_key(:detail)

    expect(errors[0][:detail]).to eq(
      "Couldn't find Market with 'id'=2352385923058"
    )
  end
end
