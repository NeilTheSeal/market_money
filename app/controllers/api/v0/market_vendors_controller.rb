module Api
  module V0
    class MarketVendorsController < ApplicationController

      def create
        if params[:market_id].empty? || params[:vendor_id].empty?
          empty_params
          return 
        end
        if market_vendor_exists?(market_vendor_params)
          already_exists
          return
        end
        @market = Market.find(params[:market_id])
        @vendor = Vendor.find(params[:vendor_id])

        @market_vendor = MarketVendor.create!(market_vendor_params)
        render json: MarketVendorSerializer.new(@market_vendor), status: 201
      end
    
      private

      def market_vendor_exists?(par)
        market_vendors = MarketVendor.where(market_id: par[:market_id], vendor_id: par[:vendor_id])
        !market_vendors.empty?
      end

      def already_exists
        error_message = ErrorMessage.new("This market vendor already exists", 422)
        serializer = ErrorSerializer.new
        serializer.add_error(error_message)
        render json: serializer.serialize_json, status: 422
      end

      def empty_params
        error_message = ErrorMessage.new("market_id and vendor_id cannot be blank", 400)
        serializer = ErrorSerializer.new
        serializer.add_error(error_message)
        render json: serializer.serialize_json, status: 400
      end

      def market_vendor_params
        params.permit(:market_id, :vendor_id)
      end
    end
  end
end