module Salt
  class Syndic < Master
    attr_accessor :syndic_master
    
    def setDefaults(salt)
      salt.install_syndic = true

      super
      
    end

    def addMasterConfig(salt)
      # add syndic-master config
      self['master_config']['syndic_master'] = self['master'].ip

      super
    end
  end
end

# Copyright (C) 2019 by Risk Focus Inc.  All rights reserved
