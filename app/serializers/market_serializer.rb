class MarketSerializer
  include JSONAPI::Serializer
  attributes :name, :street, :city, :county, :state, :zip, :lat, :lon,
             :vendor_count

  # association :vendors

  # attribute :vendor_count do |object|
  #   object.vendors.count
  # end
end
