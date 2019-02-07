require 'salt/minion'

RSpec.describe Salt::Minion do
  before :each do
    @name = "myName"
    @info = {"ip" => "199.199.199.199"}
    @role_config = {"grains" => "tmp/myName"}
    
    @obj = Salt::Minion.new(@name, @info, @role_config)
  end
  it "has a version number" do
    expect(Salt::VERSION).not_to be nil
  end

  describe "#new" do
    it "can create an object" do
      expect( @obj ).to be_kind_of(Salt::Minion)
    end
  end
  
  describe "#role" do
    it "reports role" do
      expect( @obj.role ).to eq('minion')
    end
  end
end
# Copyright (C) 2019 by Risk Focus Inc.  All rights reserved
