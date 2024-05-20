require "rails_helper"

RSpec.describe "delete a market vendor" do
  before(:each) do
    @market = create(:market)
    @vendor = create(:vendor)
    @market_vendor = MarketVendor.create!(market_id: @market.id, vendor_id: @vendor.id)
  end

  it 'can delete a market vendor' do
    delete("/api/v0/market_vendors",
      headers: { "Content-Type" => "application/json", "Accept" => "application/json" },
      params: {
        market_id: @market.id,
        vendor_id: @vendor.id
    }.to_json
    )

    expect(MarketVendor.count).to eq(0)

    expect(response).to have_http_status(204)

    expect(response.body).to eq("")
  end

  it 'returns status 404 and an error message if trying to find the vendor at a market that was deleted' do
    delete("/api/v0/market_vendors",
    headers: { "Content-Type" => "application/json", "Accept" => "application/json" },
    params: {
      market_id: @market.id,
      vendor_id: @vendor.id
    }.to_json
    )

    delete("/api/v0/market_vendors",
    headers: { "Content-Type" => "application/json", "Accept" => "application/json" },
    params: {
      market_id: @market.id,
      vendor_id: @vendor.id
    }.to_json
    )

    expect(response).to have_http_status(404)
    body = JSON.parse(response.body, symbolize_names: true)

    expect(body).to be_a(Hash)
    expect(body).to have_key(:error)
    expect(body[:error]).to be_a(String)
    expect(body[:error]).to eq("No MarketVendor relationship between market_id=#{@market.id} AND vendor_id=#{@vendor.id} exists")
  end
end