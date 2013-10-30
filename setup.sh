#!/bin/bash
vagrant destroy --force
vagrant up
ssh 127.0.0.1 -p 2222 -i `vagrant ssh-config | grep IdentityFile  | awk '{print $2}'` -l vagrant -oStrictHostKeyChecking=no < setupssh.sh
vagrant ssh