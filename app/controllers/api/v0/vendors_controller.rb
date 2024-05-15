module Api
  module V0
    class VendorsController < ApplicationController
      def show
        @vendor = Vendor.find_by(id: params[:id])

        if @vendor
          render json: VendorSerializer.new(@vendor)
        else
          error = ErrorSerializer.new
          error.invalid_id("Vendor", params[:id])

          render json: error.list_errors, status: :not_found
        end
      end
    end
  end
end
