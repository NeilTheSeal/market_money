class Market < ApplicationRecord
  validates_presence_of :name, :street, :city, :county, :state, :zip, :lat, :lon

  has_many :market_vendors
  has_many :vendors, through: :market_vendors

  def vendor_count
    vendors.count
  end

  def self.search(params)
    if params[:name] && params[:city] && params[:state]
      where(
        "name ILIKE ? AND city ILIKE ? AND state ILIKE ?",
        "%#{params[:name]}%",
        "%#{params[:city]}%",
        "%#{params[:state]}%"
      )
    elsif params[:state] && params[:city]
      where(
        "city ILIKE ? AND state ILIKE ?",
        "%#{params[:city]}%",
        "%#{params[:state]}%"
      )
    elsif params[:state] && params[:name]
      where(
        "name ILIKE ? AND state ILIKE ?",
        "%#{params[:name]}%",
        "%#{params[:state]}%"
      )
    elsif params[:name]
      where(
        "name ILIKE ?",
        "%#{params[:name]}%"
      )
    else
      where(
        "state ILIKE ?",
        "%#{params[:state]}%"
      )
    end
  end
end
