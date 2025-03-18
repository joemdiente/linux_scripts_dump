#!/bin/sh

# add in config.mk
# Custom/AddModules := example_mod
echo "make sure to run in istax src/ folder!!!!"
ln -s ./module_example_mod.in ./build/make/
ln -s ./example_mod ./vtss_appl/