require 'spec_helper'

describe Openlive::User do
  describe "instance methods" do
    describe "#artists" do
      let(:user) { Openlive::User.new(api_data.dup) }
      let(:api_data) { { "id" => "testuser", "artists" => [{ "id" => "test", "name" => "Test Artist" }] } }
      subject { user.artists }

      it { is_expected.to be_an(Array) }

      it "instantiates the artist objects" do
        expect(subject.first).to be_an(Openlive::Artist)
      end

      context "artists is empty, then not empty" do
        subject { user }

        it "updates correctly" do
          user.api_data['artists'] = []
          expect(user.artists).to eq([])
          user.api_data['artists'] = api_data['artists']
          expect(user.artists).to be_an(Array)
          expect(user.artists.first).to be_an(Openlive::Artist)
        end
      end
    end
  end

  describe "class methods" do
    describe "#find" do
      let(:attributes) do
        {
          username: "TestUserFind2",
          email: "admin+testuserfind2@piratestudios.co.uk"
        }
      end

      let!(:user) do
        VCR.use_cassette("users/find/_user_create", record: :once) do
          Openlive::User.create(attributes)
        end
      end

      around(:each) do |example|
        VCR.use_cassette("users/find/#{id}", record: :once, &example)
      end

      subject(:response) { Openlive::User.find(id) }

      context "id is present" do
        let(:id) { user.id }
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
      subject(:response) { Openlive::User.create(username: "TestUserCreate", email: "admin+testusercreate@piratestudios.co.uk") }

      around(:each) do |example|
        VCR.use_cassette("users/create", record: :once, &example)
      end

      it { is_expected.to be_an(Openlive::User) }
    end
  end
end
