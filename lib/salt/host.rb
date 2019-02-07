require 'fileutils'
require 'openssl'

# class to hide some of the configuration stuff
module Salt
  class Host
    attr_reader :name
    attr_accessor :master, :keypath, :attrib

    @@defaults = {keypath: "keys" }
    def self.defaults
      @@defaults
    end
    
    def initialize(name, info, role_config={})
      @name = name
      @info = info
      @role_config = role_config

      if !@info.has_key?("ip")
        raise ArgumentError.new("Host info hash must list ip")
      end
      # The pattern
      @keypath = @@defaults[:keypath]

      @attrib = { } # attributes hash
    end

    def role
      self.class.name.split('::').last.downcase
    end

    def ip
      @info["ip"]
    end
    
    def pub_key
      @keypath + "/#{@name}.pub"
    end
    
    def pem_key
      @keypath + "/#{@name}.pem"
    end
    
    def keygen
      rsa_key = OpenSSL::PKey::RSA.new(2048)
      Dir.mkdir( @keypath ) unless File.directory?(@keypath )
      
      unless File.exists?(@keypath + "/#{@name}.pem")
        # note we create both, so they match
        File.write(@keypath + "/#{@name}.pem", rsa_key.to_pem.to_s)
        File.write(@keypath + "/#{@name}.pub", rsa_key.public_key.to_s )
      end

    end
    
    # update the salt object with defaults
    def setDefaults(salt)
      salt.colorize = true
      
      # write the keys
      self.keygen
      salt.grains_config = @role_config["grains"]

      salt.minion_pub = pub_key
      salt.minion_key = pem_key      

    end

  end
  
  
end

# Copyright (C) 2019 by Risk Focus Inc.  All rights reserved
