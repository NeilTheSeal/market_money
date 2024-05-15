require "rails_helper"

RSpec.describe "update a vendor using an API request" do
  before(:each) do
    @vendor = create(:vendor)
  end

  it "can update a vendor" do
    patch(
      "/api/v0/vendors/#{@vendor.id}",
      params: {
        name: "Test Vendor",
        description: "A Test Vendor",
        contact_name: "Billy Billson",
        contact_phone: "1-800-555-5555",
        credit_accepted: "false"
      }
    )

    expect(response).to have_http_status(200)

    body = JSON.parse(response.body, symbolize_names: true)

    expect(body).to have_key(:data)

    data = body[:data]

    expect(data).to have_key(:id)
    expect(data[:id]).to be_a(String)

    expect(data).to have_key(:type)
    expect(data[:type]).to eq("vendor")

    expect(data).to have_key(:attributes)
    expect(data[:attributes]).to be_a(Hash)

    expect(data[:attributes]).to have_key(:name)
    expect(data[:attributes][:name]).to eq("Test Vendor")

    expect(data[:attributes]).to have_key(:description)
    expect(data[:attributes][:description]).to eq("A Test Vendor")

    expect(data[:attributes]).to have_key(:contact_name)
    expect(data[:attributes][:contact_name]).to eq("Billy Billson")

    expect(data[:attributes]).to have_key(:contact_phone)
    expect(data[:attributes][:contact_phone]).to eq("1-800-555-5555")

    expect(data[:attributes]).to have_key(:credit_accepted)
    expect(data[:attributes][:credit_accepted]).to eq(false)
  end

  it "returns a 404 with an error if an invalid vendor id is given" do
    patch(
      "/api/v0/vendors/2352385923058",
      params: {
        name: "Test Vendor",
        description: "A Test Vendor",
        contact_name: "Billy Billson",
        contact_phone: "1-800-555-5555",
        credit_accepted: "false"
      }
    )

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

  it "returns a 400 status code if any parameters are not included" do
    patch(
      "/api/v0/vendors/#{@vendor.id}",
      params: {
        name: "",
        description: "",
        contact_name: "",
        contact_phone: "",
        credit_accepted: ""
      }
    )

    expect(response).to have_http_status(400)

    body = JSON.parse(response.body, symbolize_names: true)

    expect(body).to have_key(:errors)

    errors = body[:errors]
    expect(errors).to be_an(Array)

    errors.each do |error|
      expect(error).to be_a(Hash)
      expect(error).to have_key(:detail)
    end

    expect(errors[0][:detail]).to eq(
      "name can't be blank"
    )

    expect(errors[1][:detail]).to eq(
      "description can't be blank"
    )

    expect(errors[2][:detail]).to eq(
      "contact_name can't be blank"
    )

    expect(errors[3][:detail]).to eq(
      "contact_phone can't be blank"
    )

    expect(errors[4][:detail]).to eq(
      "credit_accepted can't be blank"
    )
  end
end
