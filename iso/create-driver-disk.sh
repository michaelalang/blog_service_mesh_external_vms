#!/bin/bash

mkdir driverdisk
cd driverdisk 
dnf download -y \
  iptables-nft \
  libnftnl \
  glibc.i686 \ 
  glibc-gconv-extra.i686 \
  libgcc.i686 \
  libmnl.i686
curl -sLo istio-1.24.0-sidecar.rpm \
  https://storage.googleapis.com/istio-release/releases/1.24.0/rpm/istio-sidecar.rpm
curl -sLo istio-1.26.0-sidecar.rpm \
  https://storage.googleapis.com/istio-release/releases/1.26.0/rpm/istio-sidecar.rpm
genisoimage -r -l -o ../servicemesh-driver-disk.iso .

cd ..
