#!/usr/bin/env bash

export CAN_VERSION=$(echo "require './lib/can'; puts Can::VERSION" | ruby)

gem build can.gemspec
sudo gem install can-${CAN_VERSION}.gem
rm can-${CAN_VERSION}.gem

can version
