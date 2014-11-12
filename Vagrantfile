Vagrant.configure("2") do |config|
  config.vm.box = "ubuntu/trusty64"

  config.vm.define :proxy do |c|
    c.vm.network "private_network", ip: "192.168.33.10"
    c.vm.network "private_network", ip: "171.16.33.10", virtualbox__intnet: "infrataster-example"

    c.vm.provision :shell, inline: <<-EOC
which nginx || apt-get -y install nginx

rm -f /etc/nginx/sites-enabled/default
echo 'include /vagrant/nginx/*.conf;' > /etc/nginx/conf.d/vagrant.conf

service nginx restart
    EOC
  end

  config.vm.define :app do |c|
    c.vm.network "private_network", ip: "171.16.33.11", virtualbox__intnet: "infrataster-example"
    c.vm.provision :shell, inline: <<-EOC
set -x

which nginx || apt-get -y install nginx
rm -f /etc/nginx/sites-enabled/default
echo 'include /vagrant/mock/nginx/*.conf;' > /etc/nginx/conf.d/vagrant.conf
service nginx restart

if [ -f /tmp/app.pid ]; then
  kill -INT $(cat /tmp/app.pid)
fi
rackup --daemonize -p 8080 --host 127.0.0.1 --pid /tmp/app.pid /vagrant/mock/app.ru
    EOC
  end
end
