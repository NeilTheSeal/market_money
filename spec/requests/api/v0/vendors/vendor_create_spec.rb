require "rails_helper"

RSpec.describe "make a vendor using an API request" do
  it "can create a new vendor" do
    post(
      "/api/v0/vendors",
      params: {
        name: "Test Vendor",
        description: "A Test Vendor",
        contact_name: "Billy Billson",
        contact_phone: "1-800-555-5555",
        credit_accepted: "false"
      }
    )

    expect(response).to have_http_status(201)

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

  it "returns a 400 status code if any parameters are not included" do
    post(
      "/api/v0/vendors",
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
