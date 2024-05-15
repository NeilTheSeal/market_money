class ErrorSerializer
  def initialize
    @errors = []
  end

  def list_errors
    {
      errors: @errors.map do |error|
        {
          detail: error
        }
      end
    }
  end

  def invalid_id(type, id)
    @errors << "Couldn't find #{type} with 'id'=#{id}"
  end

  def invalid_market_vendor(market_id, vendor_id)
    @errors << "No MarketVendor with market_id=#{market_id} AND vendor_id=#{vendor_id} exists"
  end
end
