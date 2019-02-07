require 'salt/syndic'
require 'byebug'
RSpec.describe Salt::Syndic do
  before :each do
    @name = "myName"
    @info = {"ip" => "199.199.199.199",
             "grains" => "tmp/myName",
             'master' => 'master',
             'syndic_master' => 'master'
            }
    
    @obj = Salt::Syndic.new(@name, @info)
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

  describe "#registerSyndic" do
    it "can register a syndic" do
      @master = Salt::Master.new('master', {'ip' => '10.10.10.10', 'role' => 'master'})
      @master.registerSyndic(@obj)

      expect(@master['syndics']).to have_key(@obj.name)

      #key should be added to minion list (to be auto-accepted)
      expect(@master['minions']).to have_key(@obj.name)
    end
  end
  context "registered to a master" do
    before :each do
      @salt = double
      @master = Salt::Master.new('master', @info)
      @master.registerSyndic(@obj)
      @master.registerMinion(@obj)
    end
    describe "#addMasterConfig" do
      it "correctly adds the syndic_master key" do
        expect(@salt).to receive(:master_json_config=).with("{\"syndic_master\":\"199.199.199.199\"}")
        @obj.addMasterConfig(@salt)
      end
    end
  
    describe "#setDefaults" do
      before :each do
        allow(@salt).to receive(:seed_master=)
        allow(@salt).to receive(:install_master=)
      end
    
      it "should set defaults" do
        allow(@salt).to receive(:colorize=)
        allow(@salt).to receive(:grains_config=) { "bob" }
        allow(@salt).to receive(:minion_pub=)
        allow(@salt).to receive(:minion_key=)
        allow(@salt).to receive(:master_json_config=)
        allow(@salt).to receive(:minion_json_config=)
        
        expect(@salt).to receive(:install_syndic=).with(true)
        @obj.setDefaults(@salt)
      end
    end
  end
end
# Copyright (C) 2019 by Risk Focus Inc.  All rights reserved
