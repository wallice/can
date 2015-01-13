#!/usr/bin/env bash

# export CAN_VERSION=$(echo "require './lib/can'; puts Can::VERSION" | ruby)
export CAN_VERSION="$(./bin/can version)"

echo "==> Building can version '${CAN_VERSION}'..."
gem build can.gemspec

echo "==> Installing can version '${CAN_VERSION}'..."
sudo gem install can-${CAN_VERSION}.gem
rm can-${CAN_VERSION}.gem

echo "==> Testing can version..."
can version
