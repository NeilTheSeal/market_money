require "rails_helper"

# name { Faker::FunnyName.name }
# street { Faker::Address.street_address }
# city { Faker::Address.city }
# county { Faker::Address.country }
# state { Faker::Address.state }
# zip { Faker::Address.zip }
# lat { 37.740092 + rand(-0.25..0.25) }
# lon { -104.990308 + rand(-0.25..0.25) }

RSpec.describe "search for markets" do
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

  it "can retrieve markets by state" do
    get(
      "/api/v0/markets/search",
      params: {
        state: "CO"
      }
    )

    expect(response).to be_successful

    body = JSON.parse(response.body, symbolize_names: true)

    expect(body).to have_key(:data)

    data = body[:data]

    expect(data.count).to eq(2)

    data.each do |market|
      expect(market).to have_key(:id)
      expect(market[:id]).to be_a(String)

      expect(market).to have_key(:type)
      expect(market[:type]).to be_a(String)

      expect(market).to have_key(:attributes)
      expect(market[:attributes]).to be_a(Hash)
    end
  end

  it "can retrieve markets by state and city" do
    get(
      "/api/v0/markets/search",
      params: {
        state: "CO",
        city: "Colorado Springs"
      }
    )

    expect(response).to be_successful

    body = JSON.parse(response.body, symbolize_names: true)

    expect(body).to have_key(:data)

    data = body[:data]

    expect(data.count).to eq(1)
  end

  it "can retrieve markets by state, city, and name" do
    get(
      "/api/v0/markets/search",
      params: {
        state: "CO",
        city: "Colorado Springs",
        name: "Colorado Springs Market"
      }
    )

    expect(response).to be_successful

    body = JSON.parse(response.body, symbolize_names: true)

    expect(body).to have_key(:data)

    data = body[:data]

    expect(data.count).to eq(1)
  end

  it "can retrieve markets by state and name" do
    get(
      "/api/v0/markets/search",
      params: {
        state: "CO",
        name: "Colorado Springs Market"
      }
    )

    expect(response).to be_successful

    body = JSON.parse(response.body, symbolize_names: true)

    expect(body).to have_key(:data)

    data = body[:data]

    expect(data.count).to eq(1)
  end

  it "can retrieve markets by name" do
    get(
      "/api/v0/markets/search",
      params: {
        name: "Colorado Springs Market"
      }
    )

    expect(response).to be_successful

    body = JSON.parse(response.body, symbolize_names: true)

    expect(body).to have_key(:data)

    data = body[:data]

    expect(data.count).to eq(1)
  end

  it "returns a 422 if searching by city" do
    get(
      "/api/v0/markets/search",
      params: {
        city: "Denver"
      }
    )

    expect(response).to have_http_status(422)

    body = JSON.parse(response.body, symbolize_names: true)

    expect(body).to have_key(:errors)

    errors = body[:errors]
    expect(errors).to be_an(Array)

    expect(errors[0]).to be_a(Hash)
    expect(errors[0]).to have_key(:detail)

    expect(errors[0][:detail]).to eq(
      "Cannot search by city or city and name"
    )
  end

  it "returns a 422 if searching by city" do
    get(
      "/api/v0/markets/search",
      params: {
        city: "Denver",
        name: "Denver Market"
      }
    )

    expect(response).to have_http_status(422)

    body = JSON.parse(response.body, symbolize_names: true)

    expect(body).to have_key(:errors)

    errors = body[:errors]
    expect(errors).to be_an(Array)

    expect(errors[0]).to be_a(Hash)
    expect(errors[0]).to have_key(:detail)

    expect(errors[0][:detail]).to eq(
      "Cannot search by city or city and name"
    )
  end

  it "returns a 422 if any empty params" do
    get(
      "/api/v0/markets/search",
      params: {
        state: ""
      }
    )

    expect(response).to have_http_status(422)

    body = JSON.parse(response.body, symbolize_names: true)

    expect(body).to have_key(:errors)

    errors = body[:errors]
    expect(errors).to be_an(Array)

    expect(errors[0]).to be_a(Hash)
    expect(errors[0]).to have_key(:detail)

    expect(errors[0][:detail]).to eq(
      "At least one search parameter must be present"
    )
  end

  it "returns an empty array for a search with no results" do
    get(
      "/api/v0/markets/search",
      params: {
        name: "Nonexistant Market"
      }
    )

    expect(response).to be_successful

    body = JSON.parse(response.body, symbolize_names: true)

    expect(body).to have_key(:data)

    data = body[:data]

    expect(data.count).to eq(0)
  end
end
