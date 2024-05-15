require "rails_helper"

RSpec.describe "make requests for a single vendor" do
  before(:each) do
    @vendor = create(:vendor)
  end

  it "returns the vendor info as json" do
    get "/api/v0/vendors/#{@vendor.id}"

    expect(response).to be_successful

    body = JSON.parse(response.body, symbolize_names: true)

    expect(body).to have_key(:data)

    data = body[:data]

    expect(data).to have_key(:id)
    expect(data[:id]).to eq(@vendor.id.to_s)

    expect(data).to have_key(:type)
    expect(data[:type]).to eq("vendor")

    expect(data).to have_key(:attributes)
    expect(data[:attributes]).to be_a(Hash)

    expect(data[:attributes]).to have_key(:name)
    expect(data[:attributes][:name]).to eq(@vendor.name)

    expect(data[:attributes]).to have_key(:description)
    expect(data[:attributes][:description]).to eq(@vendor.description)

    expect(data[:attributes]).to have_key(:contact_name)
    expect(data[:attributes][:contact_name]).to eq(@vendor.contact_name)

    expect(data[:attributes]).to have_key(:contact_phone)
    expect(data[:attributes][:contact_phone]).to eq(@vendor.contact_phone)

    expect(data[:attributes]).to have_key(:credit_accepted)
    expect(data[:attributes][:credit_accepted]).to eq(true)
  end

  it "returns a 404 with an error if an invalid vendor id is given" do
    get "/api/v0/vendors/2352385923058"

    expect(response).to have_http_status(404)

    body = JSON.parse(response.body, symbolize_names: true)

    expect(body).to have_key(:errors)

    errors = body[:errors]
    expect(errors).to be_an(Array)

    expect(errors[0]).to be_a(Hash)
    expect(errors[0]).to have_key(:detail)

    expect(errors[0][:detail]).to eq(
      "Couldn't find Vendor with 'id'=2352385923058"
    )
  end
end
