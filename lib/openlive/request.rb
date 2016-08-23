module Openlive
  class Request < Base
    class << self
      # Perform a request against the OpenLIVE API. Generates an identical
      # method for each HTTP verb.
      #
      # @param [String] path the URI path to perform the request against
      # @param [Hash]
      #
      # @return [Openlive::Response]
      %w(get post).each do |http_method|
        define_method(http_method) do |path, params|
          params ||= {}
          response = connection.send(http_method, path, default_params.merge(params))
          Response.new(response)
        end
      end

      private

      def default_params
        {}
      end
    end
  end
end
