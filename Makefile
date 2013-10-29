#!/bin/bash

bootstrap:
	vagrant plugin install vagrant-salt

system:
	sudo salt-call state.highstate

ctecs: app database

app: FORCE
	bundle install

database: FORCE
	rake db:create
	rake db:migrate

FORCE: