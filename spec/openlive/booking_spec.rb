require 'spec_helper'

describe Openlive::Booking do
  describe "class methods" do
    let!(:user) do
      VCR.use_cassette("artists/find/_user_create", record: :none) do
        Openlive::User.create(
          username: "TestArtistUser",
          email: "admin+testartistuser@piratestudios.co.uk"
        )
      end
    end

    let!(:artist) do
      VCR.use_cassette("artists/create", record: :none) do
        Openlive::Artist.create(name: "TestArtistCreate", userId: user.id)
      end
    end

    let!(:masterbuilders) do
      VCR.use_cassette("masterbuilders/all", record: :none) do
        Openlive::MasterBuilder.all
      end
    end

    let(:masterbuilder) { masterbuilders.first }

    describe "#find" do
      pending
    end

    describe "#create" do
      subject(:response) do
        Openlive::Booking.create(
          artistId: artist.id,
          masterbuilderId: masterbuilder.id,
          start: Time.new(2016,9,10,9,0,0),
          finish: Time.new(2016,9,10,10,0,0)
        )
      end

      around(:each) do |example|
        VCR.use_cassette("bookings/create", record: :all, &example)
      end

      it { is_expected.to be_an(Openlive::Booking) }
      it { is_expected.to respond_to(:id) }
    end

    describe "#delete" do
      pending
    end
  end
end
