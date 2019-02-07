require "byebug"
require 'salt'

RSpec.describe Salt::Config do
  it "has a version number" do
    expect(Salt::VERSION).not_to be nil
  end
  
  describe "#initialize" do
    it "creates a salt config" do
      conf = Salt::Config.new()
      expect(conf).to be_kind_of(Salt::Config)
    end
    it "is initialized with a hash" do
      conf = Salt::Config.new({"foo" => "bar"})
      expect(conf).to include({"foo" => "bar"})
    end

    it "correctly merges lists of hashes" do
      conf = Salt::Config.new({"foo" => "bar"}, {"biz" => "baz"}, {"foo" => "boo"})
      expect(conf).to include({"foo" => "boo", "biz" => "baz"})
    end
    
    it "merges and correctly overwrites keys with lists of hashes" do
      conf = Salt::Config.new({"foo" => "bar"}, {"foo" => "biz"}, {"foo" => "baz"})
      expect(conf).to include({"foo" => "baz"})
    end
    
    it "supports mandatory keys" do
      conf = Salt::Config.new({"foo" => "bar"}, {"foo" => "biz"}, {"foo" => "baz"})
      expect(conf.has_keys?(["foo"])).to be true
      expect(conf.has_keys?(["bar"])).to be false
    end
      
  end
end
