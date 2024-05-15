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

      def create
        @vendor = Vendor.new(vendor_params)

        if @vendor.save
          render json: VendorSerializer.new(@vendor), status: 201
        else
          error = ErrorSerializer.new
          error.invalid_params(@vendor)

          render json: error.list_errors, status: 400
        end
      end

      def update
        @vendor = Vendor.find_by(id: params[:id])

        if @vendor
          @vendor = Vendor.update(vendor_params)[0]
          if @vendor.errors.errors.empty?
            render json: VendorSerializer.new(@vendor), status: 200
          else
            error = ErrorSerializer.new
            error.invalid_params(@vendor)

            render json: error.list_errors, status: 400
          end
        else
          error = ErrorSerializer.new
          error.invalid_id("Vendor", params[:id])

          render json: error.list_errors, status: 404
        end
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
