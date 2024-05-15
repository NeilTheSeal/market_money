module Api
  module V0
    module Markets
      class VendorsController < ApplicationController
        def index
          @market = Market.find_by(id: params[:market_id])

          if @market
            render json: VendorSerializer.new(@market.vendors)
          else
            render json: ErrorSerializer.invalid_id(
              "Market", params[:market_id]
            ), status: :not_found
          end
        end
      end
    end
  end
end
