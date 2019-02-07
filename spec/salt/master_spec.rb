require 'salt/master'

RSpec.describe Salt::Master do
  before :each do
    @name = "myName"
    @info = {
      "ip" => "199.199.199.199",
      "master_config" => {"foo" => "bar"},
      "role" => 'master'
    }
    
    @obj = Salt::Master.new(@name, @info)
  end
  it "has a version number" do
    expect(Salt::VERSION).not_to be nil
  end

  describe "#new" do
    it "can create an object" do
      expect( @obj ).to be_kind_of(Salt::Master)
    end
  end

  describe "#role" do
    it "reports role" do
      expect( @obj.role ).to eq('master')
    end
  end

  context "with minion" do
    before :each do
      @min = Salt::Minion.new('minion', {"ip" => "199.199.199.100", "grains" => "tmp/myName", "master" => 'master'})
    end
    
    describe "#registerMinion" do
      it "should know its minions" do
        expect{@obj.registerMinion(@min)}.not_to raise_error
      end
    end
    describe "#minionList" do
      it "should return the list of minion keys" do
        @obj.registerMinion(@min)
        expect(@obj.minionList).to include('minion' => 'keys/minion.pub')
      end
    end
  end
  
  context "defaults" do
    before :each do
      @salt = double
    end
    
    describe "addMasterConfig" do    
      it "should read in a json doc" do
        expect(@salt).to receive(:master_json_config=).with("{\"foo\":\"bar\"}")
        @obj.addMasterConfig(@salt)
        
      end
      it "should add order_master for masters of syndics" do
        @syndic  = Salt::Syndic.new('syndic', {"ip" => "199.199.199.100", "grains" => "tmp/myName", "master" => 'master'})
        @obj.registerMinion(@syndic)
        
        expect(@salt).to receive(:master_json_config=).with({"foo" => "bar", "order_masters" => true}.to_json)
        @obj.addMasterConfig(@salt)
        
      end
    end
    
    describe "#setDefaults" do
      before :each do
        allow(@salt).to receive(:seed_master=)
        expect(@salt).to receive(:install_master=)
      end
    
      it "should set defaults" do
        allow(@salt).to receive(:colorize=)
        allow(@salt).to receive(:grains_config=) { "bob" }
        allow(@salt).to receive(:minion_pub=)
        allow(@salt).to receive(:minion_key=)
        allow(@salt).to receive(:minion_json_config=)
        expect(@salt).to receive(:master_json_config=).with("{\"foo\":\"bar\"}")
        @obj.setDefaults(@salt)
      end
    end
  end
  
end
# Copyright (C) 2019 by Risk Focus Inc.  All rights reserved
