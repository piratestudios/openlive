require 'spec_helper'

describe Openlive::MasterBuilder do
  describe "class methods" do
    describe "#find" do
      let(:masterbuilders) do
        VCR.use_cassette("masterbuilders/all", record: :none) do
          Openlive::MasterBuilder.all
        end
      end

      subject(:response) { Openlive::MasterBuilder.find(id) }

      around(:each) do |example|
        VCR.use_cassette("masterbuilders/find/#{id}", record: :new_episodes, &example)
      end

      context "id is present" do
        let(:id) { masterbuilders.first.id }
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

    describe "#all" do
      subject { Openlive::MasterBuilder.all }

      around(:each) do |example|
        VCR.use_cassette("masterbuilders/all", record: :once, &example)
      end

      it "returns an array" do
        expect(subject).to be_an(Array)
      end
    end
  end
end
