require 'fileutils'
require 'openssl'

# class to hide some of the configuration stuff
module Salt
  class Host < Hash
    attr_reader :name
    attr_accessor :keypath

    @@defaults = {keypath: "keys" }
    def self.defaults
      @@defaults
    end

    # create the class with a name and a list of hashes
    def initialize(name, info)
      @name = name

      # this creates the configuration
      self.merge!(info)

      # The pattern
      @keypath = @@defaults[:keypath]

    end

    def role
      self.class.name.split('::').last.downcase
    end

    def ip
      self["ip"]
    end

  end
  
  
end

# Copyright (C) 2019 by Risk Focus Inc.  All rights reserved
