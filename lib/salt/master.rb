require 'json'
require 'salt'

module Salt
  class Master < Minion
    def initialize(name, info)
      self['master_config'] = {}
      self['minions'] = {}
      self['syndics'] = {}
      
      super
      
    end
    
    def registerMinion(minion)
      self['minions'][minion.name] = minion
      minion['master'] = self
    end

    def registerSyndic(syndic)
      self['syndics'][syndic.name] = syndic
      syndic['syndic_master'] = self

      # NB: in order for a syndic to work, the minion key must be
      # accepted on the master
      self['minions'][syndic.name] = syndic
      
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
      self['master_config']['order_masters'] = true unless( self['syndics'].empty? )
      salt.master_json_config = self['master_config'].to_json

    end
    
  end
  
end

# Copyright (C) 2019 by Risk Focus Inc.  All rights reserved
