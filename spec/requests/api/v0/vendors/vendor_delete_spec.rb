require "rails_helper"

RSpec.describe "update a vendor using an API request" do
  before(:each) do
    @vendor = create(:vendor)
  end

  it "can delete a vendor" do
    delete "/api/v0/vendors/#{@vendor.id}"

    expect(response).to have_http_status(204)

    expect(response.body).to eq("")
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
end
