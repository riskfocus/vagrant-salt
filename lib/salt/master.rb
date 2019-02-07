require 'json'
require 'salt'

module Salt
  class Master < Minion
    def initialize(name, info)
      self['master_config'] = {}
      self['minions'] = {}

      super
      
    end
    
    def registerMinion(minion)
      self['minions'][minion.name] = minion
      minion['master'] = self
    end

    # create the hash of minion keys that the master should be seeded with
    def minionList
      self['minions'].transform_values {|v| v.pub_key }
    end
    
    def setDefaults(salt)
        salt.seed_master = self.minionList
        salt.install_master = true
        
        addMasterConfig(salt)
        super
        
    end
    
    def addMasterConfig(salt)
      self['minions'].each do |n, v|
        if v.is_a?(Salt::Syndic)
          self['master_config']['order_masters'] = true
          break
        end
      end

      salt.master_json_config = self['master_config'].to_json

    end
    
  end
  
end

# Copyright (C) 2019 by Risk Focus Inc.  All rights reserved
