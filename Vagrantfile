Vagrant.configure("2") do |config|
  config.vm.box = "ubuntu/trusty64"

  config.vm.define :proxy do |c|
    c.vm.network "private_network", ip: "192.168.33.10"
    c.vm.network "private_network", ip: "171.16.33.10", virtualbox__intnet: "infrataster-example"
  end

  config.vm.define :app do |c|
    c.vm.network "private_network", ip: "171.16.33.11", virtualbox__intnet: "infrataster-example"
  end
end
