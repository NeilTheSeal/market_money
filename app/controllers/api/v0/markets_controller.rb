module Api
  module V0
    class MarketsController < ApplicationController
      def index 
        # markets = Market.all
        render json: MarketSerializer.new(Market.all)
      end
    end 
  end
end