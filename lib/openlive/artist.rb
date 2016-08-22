module Openlive
  class Artist < Base
    class << self
      # Find and return an artist record
      #
      # @param id [String]
      # @return [Openlive::Artist]

      def find(id)
        response = Request.get("artists/#{id}")

        handle_response(response, error_class: APIError) do |response|
          new(response.body)
        end
      end

      # Create a new artist on Openlive
      #
      # @param [Hash] params A hash of attributes to set
      # @option params [String] :name
      # @option params [Numeric] :userId
      # @return [Artist] the created artist object

      def create(params)
        response = Request.post("artists", { request: params })

        handle_response(response, error_class: APIError) do |response|
          new(response.body)
        end
      end

      # Fetch and return a list of all artists
      #
      # @return [Array<Artist>]

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
enD
