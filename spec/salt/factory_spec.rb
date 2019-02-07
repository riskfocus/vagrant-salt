require "byebug"
require 'salt'

RSpec.describe Salt::Factory do
  it "has a version number" do
    expect(Salt::VERSION).not_to be nil
  end
  
  describe "#initialize" do
    f = Salt::Factory.new({"hosts" => {}})
    it "creates a salt factory" do
      expect(f).to be_kind_of(Salt::Factory)
    end
  end
  describe "#create" do
    context "with no defaults" do
      before :each do
        @f = Salt::Factory.new({
                                 "hosts" => {
                                   "master" => {
                                     "ip" => "1.2.3.4",
                                     "role" => "master"
                                   },
                                   "minion" => {
                                       "ip" => "1.2.3.5",
                                       "role" => "minion"
                                   }
                                 }
                               })
        @hosts = @f.create
      end
      it "can create a set of objects" do
        expect(@hosts.keys.length).to eql(2)
      end
      it "can create a master node" do
        expect(@hosts).to have_key('master')
      end
      it "can create a minion node" do
        expect(@hosts).to have_key('minion')
      end
      it "fails witout a hosts section" do
        @f = expect{Salt::Factory.new({}) }.to raise_error(ArgumentError)
      end
      it "fails when a host does not have a specified role" do
        f = Salt::Factory.new({"hosts" => {"foo" => {"ip" => "1.2.4.4"}}})
        expect{f.create}.to raise_error(ArgumentError)
      end
    end
  end
end
# Copyright (C) 2019 by Risk Focus Inc.  All rights reserved
