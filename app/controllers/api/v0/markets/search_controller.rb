module Api
  module V0
    module Markets
      class SearchController < ApplicationController
        def index
          valid_search = check_valid_search(params)

          if valid_search
            @markets = Market.search(search_params)
          elsif params_empty(params)
            error_message = ErrorMessage.new(
              "At least one search parameter must be present", 422
            )
            serializer = ErrorSerializer.new
            serializer.add_error(error_message)
            render json: serializer.serialize_json, status: 422
            return
          else
            error_message = ErrorMessage.new(
              "Cannot search by city or city and name", 422
            )
            serializer = ErrorSerializer.new
            serializer.add_error(error_message)
            render json: serializer.serialize_json, status: 422
            return
          end

          render json: MarketSerializer.new(@markets)
        end

        private

        def check_valid_search(par)
          return true if par[:state].instance_of?(String) && par[:state] != ""

          unless par[:name].instance_of?(String) && par[:name] != ""
            return false
          end

          return false unless par[:city].class != String || par[:city] == ""

          true
        end

        def params_empty(par)
          return false if par[:name].instance_of?(String) && par[:name] != ""
          return false if par[:city].instance_of?(String) && par[:city] != ""
          return false if par[:state].instance_of?(String) && par[:state] != ""

          true
        end

        def search_params
          params.permit(:name, :city, :state)
        end
      end
    end
  end
end
