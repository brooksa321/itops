#!/bin/bash

#run update
yum -y update

yum -y groupinstall "Development Tools"

yum -y install wget

#Create system Directories
mkdir /usr1 /usr2 /usr3 /usr4
mkdir /usr1/apache

#Change into repo directory
cd /usr4

#Download apache
wget http://mirror.reverse.net/pub/apache//httpd/httpd-2.4.18.tar.gz

#Extract Apache
tar -xzvf httpd-2.4.18.tar.gz

#Change into extracted dir
cd httpd-2.4.18

mkdir apr pcre

cd apr

# Build and install apr 1.5.2
wget http://apache.mirrors.ionfish.org//apr/apr-1.5.2.tar.gz
tar -xzvf apr-1.5.2.tar.gz
cd apr-1.5.2
./configure --prefix=/usr/local/apr-httpd/
make
make install

cd ..

# Build and install apr-util 1.5.4
wget http://apache.mirrors.ionfish.org//apr/apr-util-1.5.4.tar.gz
tar -xzvf apr-util-1.5.4.tar.gz
cd apr-util-1.5.4
./configure --prefix=/usr/local/apr-util-httpd/ --with-apr=/usr/local/apr-httpd/
make
make install

# Build and install pcre 8.38
cd ../../
cd pcre
wget ftp://ftp.csx.cam.ac.uk/pub/software/programming/pcre/pcre-8.38.tar.gz
tar -xzvf pcre-8.38.tar.gz
cd pcre-8.38
./configure --prefix=/usr/local/pcre
make
make install

# Configure httpd
cd ../../
./configure --prefix=/usr1/apache --with-apr=/usr/local/apr-httpd/ --with-apr-util=/usr/local/apr-util-httpd/ --with-pcre=/usr/local/pcre
make
make install

#Link logs to /usr3
mkdir /usr3/apache
cd /usr3/apache/
ln -s /usr1/apache/logs/ logs

#Add Apache to rc.local to ensure it starts on boot
echo "#Start Apache on Boot" >> /etc.rc.local
echo /usr1/apache/bin/httpd -k start >> /etc.rc.local

#Start Apache
/usr1/apache/bin/httpd -k start




