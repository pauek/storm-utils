#!/bin/bash

pushd /opt
  wget https://github.com/downloads/nathanmarz/storm/storm-0.5.4.zip
  unzip storm-0.5.4.zip
  ln -s storm-0.5.4 storm
  rm storm-0.5.4.zip
popd