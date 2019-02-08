# Salt::Host

Salt::Host is a set of classes to aid in using Salt as a configurator in Vagrant.  Though salt is a built-in configurator, using it is very messy, involving repeated code, blocks of assignments and configuration that is so very not DRY.  These classes are an attempt, albeit poor and in process, to clean up the use of salt in vagrant.  Since Vagrant is packaged as a stand-alone distribution, with an embedded ruby executable, the normal ruby way of distributing / installing / using gems won't work.  The Vagrant way of extending is to create a plugin, but that seems like overkill at this point.  

## Installation

From the top level directory of your vagrant setup (the directory with the Vagrantfile), check out this code
 ```
git clone git@github.com:petermeulbroek/salt-vagrant.git
```

IF you want to run tests, you'll have to have a working ruby environment with bundler and rspec.  If you don't want to run the distribution rspec tests, skip the next steps

### Testing the classes
#### Install dependent Gems
   `bundle install --path vendor`
   *Note that this puts all needed gems in a vendor subdirectory, to avoid clashes*
#### Run tests
  `rake spec`
## Usage  
  ### Vagrantfile Updates
The classes are useable as-is, but vagrant needs to be made aware of them.  You'll need to update your Vagrantfile to use them.  
1.  The libraries need to be loaded into the Vagrant interpreter.  Note that a sample Vagrantfile is included in the top level of this distribution, and some additional topologies can be found in the examples/topology directory.  Including the files in your Vagrantfile is accomplished by the lines 
```
require 'yaml'

$LOAD_PATH.push File.expand_path('salt-vagrant/lib')
require  'salt'
```
2.  The configuration objects are created by the Salt::Factory object, based on what is specified in a yaml configuration file.   This file is loaded by including:
```
hconfig = YAML.load_file("saltconfig.yml")

# hosts is a hash of Salt host classes
hosts = Salt::Factory.new(hconfig).create
```
3. hosts are created (with proper configuration) with the remainder of the example configuration file.
### Configuration File
The host layout is specified in a file, saltconfig.yml (name defined in the Vagrantfile).  This file may contain several sections:
* **defaults**: The default values for memory and cpu for all hosts can be set here.  E.g., 
```
defaults:
   cpus: 2
   memory: 1024   # in MB
 ```
* **hosts**:  This sets the number and salt topology for hosts.  Each hosts entry must contain role, ip and salt master for each host.  The name for each created host is the dictionary key (minion1, master in the following example).  Currently, all IPs are static.  Default values from the defaults section can be overwritten on a per-host basis.  
```
hosts:
   minion1:
      role: minion
      ip: 10.1.0.10
      master: master
   master:
      role: master
      ip: 10.1.0.1
      master: master
```


## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/riskfocus/vagrant-salt

Copyright (C) 2019 by Risk Focus, Inc
