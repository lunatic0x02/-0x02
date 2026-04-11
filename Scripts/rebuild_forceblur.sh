#!/bin/bash
cd ~/builds/kwin-effects-better-blur-dx/
rm -rf build
mkdir build
cd build
cmake .. -DCMAKE_INSTALL_PREFIX=/usr
make -j$(nproc)
sudo make install
