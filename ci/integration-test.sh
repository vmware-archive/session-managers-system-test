#!/usr/bin/env bash

set -e -x

pushd session-managers-system-test
  rbenv install
  gem install bundler --no-rdoc --no-ri
  bundler install
  bundle exec rake
popd
