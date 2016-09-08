require 'spec_helper'

describe Openlive::User do
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

        it "raises an error" do
          expect { subject }.to raise_error(Openlive::APIError)
        end
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
