require 'salt/host'

module Salt
  class Minion < Host
    #    attr_accessor :master
    def initialize(name, info)
      self['minion_config'] = {}

      super
    end
    
    def pub_key
      File.join(@keypath,  "#{@name}.pub")
    end
    
    def pem_key
      File.join(@keypath,  "/#{@name}.pem")
    end
    
    def keygen
      rsa_key = OpenSSL::PKey::RSA.new(2048)
      Dir.mkdir( @keypath ) unless File.directory?(@keypath )
      
      unless File.exists?(pem_key)
        # note we create both, so they match
        File.write(pem_key, rsa_key.to_pem.to_s)
        File.write(pub_key, rsa_key.public_key.to_s )
      end

    end
    
    # update the salt object with defaults
    def setDefaults(salt)
      self['minion_config']['id'] ||= self.name
      if self['master']
        self['minion_config']['master'] ||= self['master'].ip 
      end
      
      salt.colorize = true
      
      # write the keys
      self.keygen
      salt.grains_config = self["grains"]

      salt.minion_pub = pub_key
      salt.minion_key = pem_key      

      salt.minion_json_config = self['minion_config'].to_json
    end    
  end
end

# Copyright (C) 2019 by Risk Focus Inc.  All rights reserved
