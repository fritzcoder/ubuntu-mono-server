#!/bin/bash
echo "Installing git"
apt-get install git

echo "Installing prereqs for compiling"
apt­get install autoconf automake libtool make pkg­config libgtk2.0­dev


echo "Retrieving GDI Libs"
cd /opt
mkdir mono
cd mono
git clone git://github.com/mono/libgdiplus.git

echo "Compiling GDI"
cd libgdiplus
./autogen.sh --prefix=/usr
make

echo "Installing GDI"
make install
cd ..

#test this step