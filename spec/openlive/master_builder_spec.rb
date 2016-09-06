require 'spec_helper'

describe Openlive::MasterBuilder do
  describe "class methods" do
    describe "#all" do
      subject { Openlive::MasterBuilder.all }

      around(:each) do |example|
        VCR.use_cassette("masterbuilders/all", record: :all, &example)
      end

      it "returns an array" do
        expect(subject).to be_an(Array)
      end
    end
  end
end
