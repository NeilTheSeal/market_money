class MarketVendor < ApplicationRecord
  belongs_to :vendor
  belongs_to :market

  validates_presence_of :market_id, :vendor_id
end
