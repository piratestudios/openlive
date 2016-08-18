module Openlive
  class Request < Base
    class << self
      # Perform a request against the OpenLIVE API
      #
      # @param [String] path the URI path to perform the request against
      # @param [Hash]
      #
      # @return [Openlive::Response]

      def create(path, params = {})
        response = connection.get(path, default_params.merge(params))
        Response.new(response)
      end

      private

      def default_params
        {}
      end
    end
  end
end
