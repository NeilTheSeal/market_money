module Api::V0
  class MarketVendorsController < ApplicationController
    rescue_from ActiveRecord::RecordNotFound, with: :render_not_found_response
    
    BLANK_ID_ERROR = "market_id and/or vendor_id cannot be blank".freeze
    DUPLICATE_ERROR = "This MarketVendor already exists".freeze
    
    def create
      market_id = params.fetch(:market_id, nil)
      vendor_id = params.fetch(:vendor_id, nil)

      if market_id.blank? || vendor_id.blank?
        render_bad_request_response(BLANK_ID_ERROR)
        return
      end

      market = Market.find(market_id)
      vendor = Vendor.find(vendor_id)

      if MarketVendor.exists?(market: market, vendor: vendor)
        render json: { error: DUPLICATE_ERROR }, status: :unprocessable_entity
      else
        market_vendor = MarketVendor.create(market: market, vendor: vendor)
        render json: MarketVendorSerializer.new(market_vendor), status: :created
      end
    end

    def destroy
      @market_vendor = MarketVendor.find_by!(
        market_id: params[:market_id],
        vendor_id: params[:vendor_id]
      )
      @market_vendor.destroy
      render json: "", status: :no_content
    end

    private

    def render_not_found_response(message)
      error_message = "No MarketVendor relationship between market_id=#{params[:market_id]} AND vendor_id=#{params[:vendor_id]} exists"
      render json: { error: error_message }, status: :not_found
    end

    def render_bad_request_response(message)
      render json: { error: message }, status: :bad_request
    end
  end
end
