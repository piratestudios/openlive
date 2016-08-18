module Openlive
  class MasterBuilder < Base

    class << self
      # Fetch and return a list of all master builder units
      #
      # @return [Array<MasterBuilder>]

      def all
        response = Request.create("/masterbuilders")
        binding.pry
      end
    end
  end
end
