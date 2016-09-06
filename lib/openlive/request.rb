module Openlive
  class Request < Base
    class << self
      # Perform a get request against the OpenLIVE API.
      #
      # @param [String] path the URI path to perform the request against
      # @param [Hash] params
      # @param [Hash] headers
      #
      # @return [Openlive::Response]
      def get(path, params = {}, headers = {})
        response = connection.send(
          :get,
          path,
          default_params.merge(params),
          default_headers.merge(headers)
        )

        Response.new(response)
      end

      # Perform a post request against the OpenLIVE API.
      #
      # @param [String] path the URI path to perform the request against
      # @param [Hash] params
      # @param [Hash] headers
      #
      # @return [Openlive::Response]
      def post(path, params = {}, headers = {})
        headers["Content-Type"] ||= "application/json"

        response = connection.send(
          :post,
          path,
          JSON.generate(default_params.merge(params)),
          default_headers.merge(headers)
        )

        Response.new(response)
      end

      private

      def default_params
        {}
      end

      def default_headers
        {}
      end
    end
  end
end
