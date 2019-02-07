require "salt"
require "byebug"

RSpec.describe Salt::Host do
  before :each do
    @name = "myName"
    @info = {"ip" => "199.199.199.199", "grains" => "tmp/myName"}

    
    @obj = Salt::Host.new(@name, @info)
  end
  it "has a version number" do
    expect(Salt::VERSION).not_to be nil
  end

  describe "#new" do
    it "can create an object" do
      expect( @obj ).to be_kind_of(Salt::Host)
    end
  end
  
  describe "#role" do
    it "reports role" do
      expect( @obj.role ).to eq('host')
    end
  end
  describe "#ip" do
    it "reports ip" do

      expect( @obj.ip ).to eq('199.199.199.199')
    end
  end

end
# Copyright (C) 2019 by Risk Focus Inc.  All rights reserved
