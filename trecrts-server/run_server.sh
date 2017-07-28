#!/bin/bash

while true
do
  sudo PORT=80 npm start >> log.server 2>&1 &
  wait
done