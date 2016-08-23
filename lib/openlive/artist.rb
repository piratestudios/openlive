module Openlive
  class Artist < Base
    class << self
      # Find and return an artist record
      #
      # @param id [String]
      # @return [Artist]
      # @raise [APIError] Will raise an error on unsuccessful response
      def find(id)
        response = Request.get("artists/#{id}")

        handle_response(response, error_class: APIError) do |response|
          new(response.body)
        end
      end

      # Create a new artist on Openlive
      #
      # @param [Hash] attributes A hash of attributes to set
      # @option attributes [String] :name
      # @option attributes [String] :userId
      # @return [Artist] the created artist object
      # @raise [APIError] Will raise an error on unsuccessful response
      def create(attributes)
        response = Request.post("artists", { request: attributes })

        handle_response(response, error_class: APIError) do |response|
          new(response.body)
        end
      end

      # Fetch and return a list of all artists
      #
      # @return [Array<Artist>]
      # @raise [APIError] Will raise an error on unsuccessful response
      def all
        response = Request.get("artists")

        handle_response(response, error_class: APIError) do |response|
          response.body['data'].map do |a|
            new(a)
          end
        end
      end
    end
  end
end
