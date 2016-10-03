require 'spec_helper'

describe Openlive::Artist do
  describe "class methods" do
    let(:attributes) do
      {
        username: "TestArtistUser",
        email: "admin+testartistuser@piratestudios.co.uk"
      }
    end

    let!(:user) do
      VCR.use_cassette("artists/find/_user_create", record: :none) do
        Openlive::User.create(attributes)
      end
    end

    describe "#find" do
      let(:artist) do
        VCR.use_cassette("artists/create", record: :none) do
          Openlive::Artist.create(name: "TestArtistCreate", userId: user.id)
        end
      end

      subject(:response) do
        VCR.use_cassette("artists/find/#{id}", record: :none) do
          Openlive::Artist.find(id)
        end
      end

      context "id is present" do
        let(:id) { artist.id }
        subject { response.response.success? }

        it { is_expected.to be true }
      end

      context "id is incorrect" do
        let(:id) { "incorrect_id" }
        subject { response }

        it { is_expected.to be nil }
      end
    end

    describe "#create" do
      subject(:response) do
        VCR.use_cassette("artists/create", record: :none) do
          Openlive::Artist.create(name: "TestArtistCreate", userId: user.id)
        end
      end

      it { is_expected.to be_an(Openlive::Artist) }
    end

    describe "#all" do
      subject { Openlive::Artist.all }

      around(:each) do |example|
        VCR.use_cassette("artists/all", record: :none, &example)
      end

      it "returns an array" do
        expect(subject).to be_an(Array)
      end
    end
  end
end
