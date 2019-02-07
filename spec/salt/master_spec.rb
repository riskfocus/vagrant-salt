require 'salt/master'

RSpec.describe Salt::Master do
  before :each do
    @name = "myName"
    @info = {"ip" => "199.199.199.199",
             "minions" => ['minion1', 'minion2', 'minion3']
            }
    
    @role_config = {
      "master_config" => "tmpfile"
    }
    
    @obj = Salt::Master.new(@name, @info, @role_config)
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

  describe "#minionList" do
    it "should return the list of minion keys" do
      @obj.keypath = "tmp"
      expect(@obj.minionList).to match_array @info['minions'].map {|m| [m, "tmp/#{m}.pub"] }
    end
  end

  context "defaults" do
    before :each do
      allow(File).to receive(:read).and_return(<<END)
{
   "foo": "bar"
}
END
      @salt = double
    end
    
    describe "addMasterConfig" do    
      it "should read in a json doc" do
        @obj.keypath = "."
        expect(@salt).to receive(:master_json_config=).with("{ \"foo\": \"bar\" } ")
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
        
        expect(@salt).to receive(:master_json_config=).with("{ \"foo\": \"bar\" } ")
        @obj.setDefaults(@salt)
      end
    end
  end
  
end
# Copyright (C) 2019 by Risk Focus Inc.  All rights reserved
