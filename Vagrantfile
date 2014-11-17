# -*- mode: ruby -*-
# vi: set ft=ruby :

# hosts = %w!app-foo-001!
hosts = %w!app-001!

Vagrant.configure("2") do |config|
  config.vm.box = "ubuntu/trusty64"

  config.vm.define :proxy do |c|
    c.vm.network "private_network", ip: "192.168.33.10"
    c.vm.network "private_network", ip: "172.16.33.10", virtualbox__intnet: "infrataster-example"

    etc_hosts = "127.0.0.1 localhost\n"
    etc_hosts += hosts.each_with_index.map do |host, index|
      "172.16.34.#{index + 1} #{host}"
    end.join("\n")

    c.vm.provision :shell, inline: <<-EOC
echo #{Shellwords.escape(etc_hosts)} > /etc/hosts

/sbin/route add -net 172.16.34.0 netmask 255.255.255.0 gw 172.16.33.11

which nginx || apt-get -y install nginx
rm -f /etc/nginx/sites-enabled/default
echo 'include /vagrant/nginx/*.conf;' > /etc/nginx/conf.d/vagrant.conf
service nginx restart
    EOC
  end

  config.vm.define :app do |c|
    c.vm.network "private_network", ip: "172.16.33.11", virtualbox__intnet: "infrataster-example"

    nginx_conf = hosts.each_with_index.map do |host, index|
      <<-EOC
server {
  listen 172.16.34.#{index + 1}:80;
  server_name #{host};

  location / {
    proxy_pass http://localhost:8080;
    proxy_set_header X-MOCK-HOST #{host};
  }
}
      EOC
    end.join("\n\n")

    c.vm.provision :shell, inline: <<-EOC
for i in `seq 1 255`; do
  ip addr show eth1 | grep -q -F 172.16.34.$i || ip addr add 172.16.34.$i/24 dev eth1
done

which nginx || apt-get -y install nginx
rm -f /etc/nginx/sites-enabled/default
echo #{Shellwords.escape(nginx_conf)} > /etc/nginx/conf.d/mock.conf
service nginx restart

if [ -f /tmp/app.pid ]; then
  kill -INT $(cat /tmp/app.pid)
fi
rackup --daemonize -p 8080 --host 127.0.0.1 --pid /tmp/app.pid /vagrant/mock/app.ru
    EOC
  end
end
