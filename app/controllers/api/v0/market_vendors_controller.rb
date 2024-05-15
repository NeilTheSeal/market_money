module Api
  module V0
    class MarketVendorsController < ApplicationController
      rescue_from ActiveRecord::RecordInvalid, with: :not_found_response
      def create
          @market_vendor = MarketVendor.create!(market_vendor_params)
          render json: MarketVendorSerializer.new(@market_vendor), status: 201
      end

      private

      def not_found_response(exception)
        error_message = ErrorMessage.new(exception.message, 404)
        serializer = ErrorSerializer.new
        serializer.add_error(error_message)
        render json: serializer.serialize_json, status: 404
      end

      def market_vendor_params
        params.permit(:market_id, :vendor_id)
      end
    end
  end
end