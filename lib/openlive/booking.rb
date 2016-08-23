module Openlive
  class Booking < Base
    class << self
      # Find and return a booking record
      #
      # @param id [String]
      # @return [Booking]
      # @raise [APIError] Will raise an error on unsuccessful response
      def find(id)
        response = Request.get("bookings/#{id}")

        handle_response(response, error_class: APIError) do |response|
          new(response.body)
        end
      end

      # Create a new booking on Openlive
      #
      # @param [Hash] attributes A hash of attributes to set
      # @option attributes [String] :artistId
      # @option attributes [String] :masterbuilderId
      # @option attributes [Time] :start
      # @option attributes [Time] :finish
      # @return [Booking] the created booking object
      # @raise [APIError] Will raise an error on unsuccessful response
      def create(attributes)
        response = Request.post("bookings", { request: attributes })

        handle_response(response, error_class: APIError) do |response|
          new(response.body)
        end
      end

      def delete(id)
        response = Request.delete("bookings/#{id}")
      end
    end
  end
end
