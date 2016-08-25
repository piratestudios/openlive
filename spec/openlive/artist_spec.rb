require 'spec_helper'

describe Openlive::Artist do
  describe "class methods" do
    describe "#find" do
      subject(:response) { Openlive::Artist.find(id) }

      around(:each) do |example|
        VCR.use_cassette("artists/find", &example)
      end

      context "id is present" do
        let(:id) { 1 }
        subject { response.success? }

        it { is_expected.to be true }
      end

      context "id is not present" do
        let(:id) { nil }
        subject { response.success? }

        it { is_expected.to be false }
      end
    end

    describe "#all" do
      subject { Openlive::Artist.all }

      around(:each) do |example|
        VCR.use_cassette("artists/all", &example)
      end

      it "returns successfully" do
        expect(subject.success?).to be true
      end
    end
  end
end
