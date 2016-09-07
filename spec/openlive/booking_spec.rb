require 'spec_helper'

describe Openlive::Booking do
  describe "class methods" do
    let!(:user) do
      VCR.use_cassette("artists/find/_user_create", record: :new_episodes) do
        Openlive::User.create(
          username: "TestArtistUser",
          email: "admin+testartistuser@piratestudios.co.uk"
        )
      end
    end

    let!(:artist) do
      VCR.use_cassette("artists/create", record: :new_episodes) do
        Openlive::Artist.create(name: "TestArtistCreate", userId: user.id)
      end
    end

    let!(:masterbuilders) do
      VCR.use_cassette("masterbuilders/all", record: :new_episodes) do
        Openlive::MasterBuilder.all
      end
    end

    let(:masterbuilder) { masterbuilders.first }

    describe "#find" do
      subject(:response) do
        VCR.use_cassette("bookings/find/#{id}", record: :new_episodes) do
          Openlive::Booking.find(id)
        end
      end

      context "id is present" do
        # Got fed up with VCR crap, hardcoding ID for now
        let(:id) { "_iIprHUDEeaBPhLdFegN5Q" }
        subject { response.response.success? }

        it { is_expected.to be true }
      end

      context "id is incorrect" do
        let(:id) { "incorrect_id" }
        subject { response }

        it "raises an error" do
          expect { subject }.to raise_error(Openlive::APIError)
        end
      end
    end

    describe "#create" do
      subject(:response) do
        Openlive::Booking.create(
          artistId: artist.id,
          masterbuilderId: masterbuilder.id,
          start: Time.new(2016,9,10,11,0,0),
          finish: Time.new(2016,9,10,12,0,0)
        )
      end

      around(:each) do |example|
        VCR.use_cassette("bookings/create", record: :new_episodes, &example)
      end

      it { is_expected.to be_an(Openlive::Booking) }
    end

    describe "#delete" do
      subject(:response) do
        VCR.use_cassette("bookings/delete", record: :new_episodes) do
          Openlive::Booking.delete(id)
        end
      end

      context "id is present" do
        let(:id) { "_iIprHUDEeaBPhLdFegN5Q" }
        subject { response }

        it { is_expected.to be true }
      end

      context "id is incorrect" do
        let(:id) { "incorrect_id" }
        subject { response }

        it "raises an error" do
          expect { subject }.to raise_error(Openlive::APIError)
        end
      end
    end
  end
end
