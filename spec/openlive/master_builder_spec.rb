require 'spec_helper'

describe Openlive::MasterBuilder do
  describe "class methods" do
    describe "#all" do
      subject { Openlive::MasterBuilder.all }

      around(:each) do |example|
        VCR.use_cassette("masterbuilders/all", &example)
      end

      it "returns successfully" do
        expect(subject.success?).to be true
      end
    end
  end
end
