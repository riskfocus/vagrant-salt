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
        # get the correct configuration:  defaults, hosts, object
        conf = Salt::Config.new(
          @info["defaults"],
          (@info.has_key?("roles")? @info["roles"][ v["role"] ] : {}),
          v
        )
        # each host must have a role and an ip
        if !conf.has_keys?(["role", "ip"])
          raise ArgumentError.new("\"#{n}\" must have a role and an ip")
        end
        
        hostlist[n] = _createhost(n, conf)
      end
      
      # now that all objects are created, set their masters
      hostlist.each do |n, v|
        # sets v['master'] to the object
        hostlist[ v['master'] ].registerMinion(v)
      end
      
      return hostlist
    end
    
    private
    
    def _createhost(name, info)
      klass = "Salt::" + info["role"].capitalize
      return Kernel.const_get(klass).new(name, info )
    end
  end
end
# Copyright (C) 2019 by Risk Focus Inc.  All rights reserved
