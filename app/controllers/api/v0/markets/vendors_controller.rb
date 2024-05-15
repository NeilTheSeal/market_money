module Api
  module V0
    module Markets
      class VendorsController < ApplicationController
        def index
          @market = Market.find_by(id: params[:market_id])

          if @market
            render json: VendorSerializer.new(@market.vendors)
          else
            error = ErrorSerializer.new
            error.invalid_id("Market", params[:market_id])

            render json: error.list_errors, status: :not_found
          end
        end
      end
    end
  end
end
