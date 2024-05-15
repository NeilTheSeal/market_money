module Api
  module V0
    class MarketsController < ApplicationController
      def index
        render json: MarketSerializer.new(Market.all)
      end
    end
  end
end
