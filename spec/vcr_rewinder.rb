# Require this file in spec_helper to show which cassettes are not being used
# after the test suite has run. Then you can decide if you want to delete them.

require 'vcr'
require 'set'
USED_CASSETTES = Set.new

module CassetteReporter
  def insert_cassette(name, options = {})
    USED_CASSETTES << VCR::Cassette.new(name, options).file
    super
  end
end
VCR.extend(CassetteReporter)

RSpec.configure do |config|
  config.after(:suite) do
    cassettes = Dir['fixtures/vcr_cassettes/*.yml'].map { |d| File.expand_path(d) } - USED_CASSETTES.to_a
    if cassettes.empty?
      puts "\nHooray, all cassettes are being used!"
    else
      puts "\nUnused cassettes:"
      puts cassettes.map { |f| File.basename(f) }
    end
  end
end
