#!/bin/bash

bootstrap:
	vagrant plugin install vagrant-salt

system:
	sudo salt-call state.highstate
	bundle install

database:
	rake db:create
	rake db:migrate

env: system database

app:
	bundle install
	rake db:create
	rake db:migrate