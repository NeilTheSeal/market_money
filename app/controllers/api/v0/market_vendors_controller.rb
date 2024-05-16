module Api
  module V0
    class MarketVendorsController < ApplicationController
      def create
        return if check_for_errors

        @market = Market.find(params[:market_id])
        @vendor = Vendor.find(params[:vendor_id])

        @market_vendor = MarketVendor.create!(market_vendor_params)
        render json: MarketVendorSerializer.new(@market_vendor), status: 201
      end

      def destroy
        @market_vendor = MarketVendor.find_by!(
          market_id: params[:market_id],
          vendor_id: params[:vendor_id]
        )
        @market_vendor.destroy
        render json: "", status: 204
      rescue ActiveRecord::RecordNotFound
        render json: {
          error: "No MarketVendor with market_id=#{params[:market_id]} AND vendor_id=#{params[:vendor_id]} exists"
        }, status: 404
      end

      private

      def market_vendor_exists?(par)
        market_vendors = MarketVendor.where(
          market_id: par[:market_id],
          vendor_id: par[:vendor_id]
        )
        !market_vendors.empty?
      end

      def already_exists
        error_message = ErrorMessage.new(
          "This market vendor already exists", 422
        )
        serializer = ErrorSerializer.new
        serializer.add_error(error_message)
        render json: serializer.serialize_json, status: 422
        true
      end

      def empty_params
        error_message = ErrorMessage.new(
          "market_id and vendor_id cannot be blank", 400
        )
        serializer = ErrorSerializer.new
        serializer.add_error(error_message)
        render json: serializer.serialize_json, status: 400
        true
      end

      def market_vendor_params
        params.permit(:market_id, :vendor_id)
      end

      def check_for_errors
        return empty_params if invalid_params?

        return already_exists if market_vendor_exists?(market_vendor_params)

        false
      end

      def invalid_params?
        if params[:market_id].instance_of?(Integer) && params[:vendor_id].instance_of?(Integer)
          return false
        end

        unless params[:market_id].instance_of?(Integer)
          return params[:market_id].empty? || params[:market_id].nil?
        end

        return if params[:vendor_id].instance_of?(Integer)

        params[:vendor_id].empty? || params[:vendor_id].nil?
      end
    end
  end
end
