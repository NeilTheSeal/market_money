class MarketVendor < ApplicationRecord
  belongs_to :vendor
  belongs_to :market

  validates :market_id, presence: true
  validates :vendor_id, presence: true
  # validates_presence_of :market_id, :vendor_id
end