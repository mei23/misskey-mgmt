#!/bin/bash

export NODE_ENV=production
pushd /home/misskey/live > /dev/null
. ~/.nvm/nvm.sh
nvm install $(cat .node-version)
nvm use $(cat .node-version)

npx yarn build
sudo systemctl stop misskey.service
npx yarn migrate
sudo systemctl start misskey.service
popd > /dev/null

sudo systemctl status --full --no-pager misskey.service

/home/misskey/wait-for-boot.sh

