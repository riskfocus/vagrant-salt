require 'salt/minion'
module Salt
  class Master < Minion
    
    # create the list of minion keys that the master should be seeded with
    def minionList
      keylist = {}
      @info['minions'].each do |h|
        keylist[h] = @keypath + "/#{h}.pub"
      end
      return keylist
    end
    
    def setDefaults(salt)
        salt.seed_master = self.minionList
        salt.install_master = true
        
        addMasterConfig(salt)
        super
        
    end
    
    def addMasterConfig(salt)
      if @role_config.has_key?('master_config')
        mconf = File.read(@role_config['master_config']).gsub(/\n\s*/, " ")
        salt.master_json_config = eval("\"" + mconf.gsub(/"/, '\"') + "\"")
      end
    end
    
  end
  
end

# Copyright (C) 2019 by Risk Focus Inc.  All rights reserved
