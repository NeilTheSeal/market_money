module Api
  module V0
    class VendorsController < ApplicationController
      def show
        @vendor = Vendor.find(params[:id])
        render json: VendorSerializer.new(@vendor)
      end

      def create
        @vendor = Vendor.create!(vendor_params)
        render json: VendorSerializer.new(@vendor), status: 201
      end

      def update
        @vendor = Vendor.find(params[:id])
        @vendor.update!(vendor_params)
        render json: VendorSerializer.new(@vendor), status: 200
      end

      def destroy
        @vendor = Vendor.find(params[:id])
        @vendor.destroy
        render "", status: 204
      end

      private

      def vendor_params
        params.permit(
          :name,
          :description,
          :contact_name,
          :contact_phone,
          :credit_accepted
        )
      end
    end
  end
end
