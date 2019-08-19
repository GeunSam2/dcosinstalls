#!/bin/bash

[ -d usr/local/bin ] || sudo mkdir -p /usr/local/bin
curl https://downloads.dcos.io/binaries/cli/linux/x86-64/dcos-1.13/dcos -o dcos
sudo mv dcos /usr/local/bin
chmod +x /usr/local/bin/dcos
