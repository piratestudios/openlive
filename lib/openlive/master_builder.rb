module Openlive
  class MasterBuilder < Base
    class << self
      # Find and return a masterbuilder record
      #
      # @param id [String]
      # @return [MasterBuilder]
      # @raise [APIError] Will raise an error on unsuccessful response
      def find(id)
        response = Request.get("masterbuilders/#{id}")

        handle_response(response, error_class: APIError) do |response|
          new(response.body, response: response)
        end
      end

      # Fetch and return a list of all master builder units
      #
      # @return [Array<MasterBuilder>]
      # @raise [APIError] Will raise an error on unsuccessful response
      def all
        response = Request.get("masterbuilders")

        handle_response(response, error_class: Openlive::APIError) do |response|
          response.body['data'].map do |mb|
            new(mb, response: response)
          end
        end
      end
    end
  end
end
