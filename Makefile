#!/bin/bash

bootstrap:
	vagrant plugin install vagrant-salt

salt: FORCE
	sudo salt-call state.highstate

FORCE: