module Api
  module V0
    class MarketsController < ApplicationController
      def index
        render json: MarketSerializer.new(Market.all)
      end

      def show
        render json: MarketSerializer.new(Market.find(params[:id]))
      end

      def nearest_atms
        market = Market.find(params[:id])
        atms = TomTomFacade.nearest_atms(market.lat, market.lon)
        render json: AtmSerializer.new(atms)
      end
    end
  end
end
