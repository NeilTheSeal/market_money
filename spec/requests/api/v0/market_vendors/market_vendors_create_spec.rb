require "rails_helper"

RSpec.describe "create a new association between a market and a vendor" do
  before(:each) do
    @market = create(:market)
    @vendor = create(:vendor)
  end

  it 'US-8, creates a MarketVendor' do
    
    post(
      "/api/v0/market_vendors",
      params: {
        market_id: @market.id.to_s,
        vendor_id: @vendor.id.to_s
      }
    )

    expect(response).to have_http_status(201)

    body = JSON.parse(response.body, symbolize_names: true)

    expect(body).to have_key(:data)

    data = body[:data]

    expect(data).to have_key(:id)
    expect(data[:id]).to be_a(String)

    expect(data).to have_key(:type)
    expect(data[:type]).to eq("market_vendor")

    expect(data).to have_key(:attributes)
    expect(data[:attributes]).to be_a(Hash)

    expect(data[:attributes]).to have_key(:market_id)
    expect(data[:attributes][:market_id]).to eq(@market.id)

    expect(data[:attributes]).to have_key(:vendor_id)
    expect(data[:attributes][:vendor_id]).to eq(@vendor.id)

    vendors_for_market = Market.first.vendors
    expect(vendors_for_market.count).to eq(1)
  end

  it 'returns 404 status if an invalid vendor/market_id is given' do
    post(
      "/api/v0/market_vendors",
      params: {
        market_id: @market.id,
        vendor_id: 10001
      }
    )
    # require 'pry'; binding.pry
    expect(response).to have_http_status(404)

    body = JSON.parse(response.body, symbolize_names: true)
    
    expect(body).to be_an(Hash)
    expect(body).to have_key(:error)
  
    error = body[:error]
    expect(error).to be_a(String)


    expect(error).to eq(
      "No MarketVendor relationship between market_id=#{@market.id} AND vendor_id=10001 exists"
    )
  end

  it 'returns 400 status if a vendor and/or a market id are not given' do
    post(
      "/api/v0/market_vendors",
      params: {
        market_id: "",
        vendor_id: ""
      }
    )
    expect(response).to have_http_status(400)

    body = JSON.parse(response.body, symbolize_names: true)

    expect(body).to have_key(:error)
    expect(body).to be_an(Hash)

    error = body[:error]
    expect(error).to be_an(String)

    expect(error).to eq("market_id and/or vendor_id cannot be blank")
  end

  it 'returns 422 when trying to create a marketvendor that already exists' do
    post(
      "/api/v0/market_vendors",
      params: {
        market_id: @market.id.to_s,
        vendor_id: @vendor.id.to_s
      }
    )

    post(
      "/api/v0/market_vendors",
      params: {
        market_id: @market.id.to_s,
        vendor_id: @vendor.id.to_s
      }
    )

    expect(response).to have_http_status(422)

    body = JSON.parse(response.body, symbolize_names: true)
    
    expect(body).to be_a(Hash)
    expect(body).to have_key(:error)

    error = body[:error]
    expect(error).to be_an(String)
    
    expect(error).to eq(
      "This MarketVendor already exists"
    )
  end
end