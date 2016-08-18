require 'pry'

module Openlive
  class MasterBuilder < Base
    attr_accessor :api_data

    def initialize(data)
      self.api_data = data
    end

    class << self
      # Fetch and return a list of all master builder units
      #
      # @return [Array<MasterBuilder>]

      def all
        response = Request.create("masterbuilders")

        if response.success?
          response.body['data'].map do |mb|
            new(mb)
          end
        else
          raise APIError, "masterbuilders endpoint returned a #{response.status} status"
        end
      end
    end
  end
end
