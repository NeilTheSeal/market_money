require "rails_helper"

RSpec.describe Vehicle, type: :model do
  describe "validations" do
    it { should validate_presence_of :make }
    it { should validate_presence_of :model }
    it { should validate_presence_of :year }
  end

  describe "initialization" do
    it "has attributes" do
      vehicle = create(:vehicle)

      expect(vehicle.make).to be_a(String)
      expect(vehicle.model).to be_a(String)
      expect(vehicle.year).to be_a(Integer)
    end
  end
end
