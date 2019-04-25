#!/bin/bash

pushd /home/misskey/live > /dev/null
git fetch --all
git checkout suki.tsuki.network > /dev/null 2>&1
git status | grep "up to date"
if [[ $? -eq 0 ]]; then exit 0; fi
git reset --hard origin/suki.tsuki.network
nvm install $(cat .node-version)
nvm use $(cat .node-version)

npm install -g npm
npm run clean
npm install
NODE_ENV=production npm run build
sudo systemctl stop misskey.service
sudo systemctl start misskey.service
popd > /dev/null

sudo systemctl status --full --no-pager misskey.service

