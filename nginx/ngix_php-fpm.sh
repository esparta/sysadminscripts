!/bin/bash
## ngix_php-fpm.sh
## Developer: Espartaco Palma (esparta@gmail.com)
## Date: 2013-01-10
## LastMod: 2013-01-11
## License: GPL
## Description: Installing Nginx+PHP-fpm on RedHat/Centos/Oracle Linux 6
##    getting last-versions.
## Tested on: RHEL6.3 , Centos 6.3 & Oracle Linux 6.3
## Reference(s):
##    http://www.cyberciti.biz/faq/install-nginx-centos-rhel-6-server-rpm-using-yum-command/
##    https://www.digitalocean.com/community/articles/how-to-install-linux-nginx-mysql-php-lemp-stack-on-centos-6


## Getting last repo of nginx
#cd /tmp
#wget http://nginx.org/packages/centos/6/noarch/RPMS/nginx-release-centos-6-0.el6.ngx.noarch.rpm
#rpm -ivh nginx-release-rhel-6-0.el6.ngx.noarch.rpm
distro=$(head -1 /etc/issue | awk '{ print $1}')
distro=${distro,,}
case "$distro" in
  "centos")          echo "Adding Centos repository.";;
  "red"|"oracle")    echo "Adding RedHat repository."
   distro="rhel";;
esac
rpm -Uhv http://nginx.org/packages/$distro/6/noarch/RPMS/nginx-release-$distro-6-0.el6.ngx.noarch.rpm

yum install nginx
## start nginx on runlevels 2,3 and 5
chkconfig chkconfig --levels 235 nginx on
service nginx start

## optional
## --- Install prioties,
yum install yum-plugin-priorities
echo "priotiry=1" >> /etc/yum.repos.d/nginx.repo
echo "priotiry=1" >> /etc/yum.repos.d/nginx.repo
## PHP-fpm
## First, install auxiliar repositories (EPEL)
rpm -Uvh http://download.fedoraproject.org/pub/epel/6/i386/epel-release-6-8.noarch.rpm
## Second, REMI repositories (with the last php-fpm packages)
rpm -Uvh http://rpms.famillecollet.com/enterprise/remi-release-6.rpm
## Now we have a chance to install php-fpm
yum --enablerepo=remi install php-fpm php-mysql  php-cli
## Change FPM settings
sed -i 's/apache/nginx/g' /etc/php-fpm.d/www.conf

## config the php-fpm service to start on runlevels 2,3 and 5
chkconfig --levels 235 php-fpm on
## init the service
service php-fpm restart

##TODO: Set the IPtables
