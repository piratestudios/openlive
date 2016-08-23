module Openlive
  class MasterBuilder < Base
    class << self
      # Fetch and return a list of all master builder units
      #
      # @return [Array<MasterBuilder>]
      # @raise [APIError] Will raise an error on unsuccessful response
      def all
        response = Request.get("masterbuilders")

        handle_response(response, error_class: APIError) do |response|
          response.body['data'].map do |mb|
            new(mb)
          end
        end
      end
    end
  end
end
