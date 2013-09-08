#!/bin/bash
$script_dir = pwd
echo "***********************************************************************"
echo "*                                                                     *"
echo "* Ubuntu MONO Server Install v0.5	                                    *"
echo "* -------------------------------------------------------------	    *"
echo "* This script will build and install the latest stable version of     *"
echo "* mono [3.2.1] and install nginx, fastcgi-mono-server4 to run .net 4  *" 
echo "* applications.                                                       *"
echo "* This operation can take a while as it will download compile and     *"
echo "* install from source on most packages.                               *"
echo "*                                                                     *"
echo  "**********************************************************************"

echo "WARNING! This will overwrite your existing mono setup,uninstall Apache 
and install nginx, Would you like to continue?"

select yn in "Yes" "No"; do
    case $yn in
        Yes )  
       
		echo "make sure apt-get is updated"
		apt-get update
		echo "remove packages that are no longer needed"
		apt-get autoremove

		echo "Installing git"
		apt-get install git

		echo "Installing prereqs for compiling"
		apt-get install autoconf automake libtool make pkg-config libgtk2.0-dev

		echo "Cloning GDI source, compiling and installing."
		cd /opt
		mkdir mono
		cd mono
		git clone git://github.com/mono/libgdiplus.git

		cd libgdiplus
		./autogen.sh --prefix=/usr
		make
		make install
		cd ..

		echo "Cloning Mono source, compiling and installing"
		git clone git://github.com/mono/mono.git
		cd mono
		git checkout mono-3.2.1
		./autogen.sh --prefix=/usr

		make get-monolite-latest
		make EXTERNAL_MCS=${PWD}/mcs/class/lib/monolite/gmcs.exe
		make install
		cd ..

		echo "Cloning XSP source compile and installing for fastcgi mod"
		git clone git://github.com/mono/xsp.git 
		cd xsp
		git checkout 3.0.11
		./autogen.sh --prefix=/usr 
		make
		make install
		
		echo "Removing apache and installing nginx"
		service apache2 stop
		apt-get remove apache2
		apt-get install nginx
		service nginx start
		
		echo "Creating start up script for fastcgi-mono-server4"
		DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
		cd "$DIR"
		cp monoserve /etc/init.d/
		chmod +x /etc/init.d/monoserve
		echo "fastcgi-mono-server4 starting tcp:127.0.0.1:9000"
		/etc/init.d/monoserve start
		update-rc.d monoserve defaults
		
		cp fastcgi_params /etc/nginx/
		mkdir /etc/mono
		mkdir /etc/mono/fastcgi
		mkdir /var/log/mono
		
		service nginx restart
		break;;

	 	No ) echo "OK bye."; exit;;
  esac
done

