# class to create salt roles
require 'salt'
module Salt
  class Factory
    def initialize(info)
      @info = info
      if !@info.has_key?("hosts")
        raise ArgumentError.new("config must contain a \"hosts\" key")
      end
      
    end
    
    def create
      hostlist = {}
      @info["hosts"].each do |n, v|
        hostlist[n] = _createhost(n, v)

        # note:  we can add additional attributes here.  Can we be smarter?
        ["memory", "cpus"].each do |att|
          if v.has_key?(att) || ( @info.has_key?('defaults') && @info['defaults'].has_key?(att) )
            hostlist[n].attrib[att] = v[att] || @info['defaults'][att]
          end
        end
      end
      
      # now that all objects are created, set their masters and syndics
      hostlist.each do |n, v|
        v.master = hostlist[@info['hosts'][n]['master']]
        
        if v.respond_to?(:syndic_master)
          v.syndic_master = hostlist[@info['hosts'][n]['syndic_master']]
        end
      end
      
      return hostlist
    end
    
    private
    
    def _createhost(name, info)
      if !info.has_key?("role")
        raise ArgumentError.new("host config must contain a \"role\" key")
      end
      # we'll initialize the class based on the role listed in the config file
      klass = "Salt::" + info["role"].capitalize
      if @info.has_key?("roles")
        return Kernel.const_get(klass).new(name, info, @info["roles"][info["role"]])
      else
        return Kernel.const_get(klass).new(name, info )
      end
    end
    
  end
end
# Copyright (C) 2019 by Risk Focus Inc.  All rights reserved
