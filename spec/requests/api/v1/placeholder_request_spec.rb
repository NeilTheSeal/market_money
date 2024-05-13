require "rails_helper"

RSpec.describe "API - get vehicles index" do
  before(:each) do
    @vehicles = create_list(:vehicle, 3)
  end

  it "should return vehicles as json" do
    create_list(:vehicle, 3)

    get "/api/v1/vehicles"

    expect(response).to be_successful

    vehicles = JSON.parse(response.body, symbolize_names: true)

    expect(vehicles.count).to eq(3)

    vehicles.each do |vehicle|
      expect(vehicle).to have_key(:id)
      expect(vehicle[:id]).to be_an(Integer)

      expect(vehicle).to have_key(:make)
      expect(vehicle[:make]).to be_a(String)

      expect(vehicle).to have_key(:model)
      expect(vehicle[:model]).to be_a(String)

      expect(vehicle).to have_key(:year)
      expect(vehicle[:year]).to be_an(Integer)
    end
  end
end
