require 'salt/syndic'

RSpec.describe Salt::Syndic do
  before :each do
    @name = "myName"
    @info = {"ip" => "199.199.199.199",
             "minions" => []
            }
    @role_config = {"grains" => "tmp/myName"}
    
    @obj = Salt::Syndic.new(@name, @info, @role_config)
  end
  it "has a version number" do
    expect(Salt::VERSION).not_to be nil
  end

  describe "#new" do
    it "can create an object" do
      expect( @obj ).to be_kind_of(Salt::Syndic)
    end
  end
  
  describe "#role" do
    it "reports role" do
      expect( @obj.role ).to eq('syndic')
    end
  end
    describe "#setDefaults" do
    before :each do
      allow(File).to receive(:read).and_return("")
      @salt = double
      allow(@salt).to receive(:seed_master=)
      allow(@salt).to receive(:install_master=)
    end
    
    it "should set defaults" do
      allow(@salt).to receive(:colorize=)
      allow(@salt).to receive(:grains_config=) { "bob" }
      allow(@salt).to receive(:minion_pub=)
      allow(@salt).to receive(:minion_key=)
      allow(@salt).to receive(:master_json_config=)

      expect(@salt).to receive(:install_syndic=)
      @obj.setDefaults(@salt)
    end
    end
    
end
# Copyright (C) 2019 by Risk Focus Inc.  All rights reserved
