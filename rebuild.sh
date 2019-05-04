#!/bin/bash

export NODE_ENV=production
pushd /home/misskey/live > /dev/null
. ~/.nvm/nvm.sh
nvm install $(cat .node-version)
nvm use $(cat .node-version)

npm run build
sudo systemctl stop misskey.service
ts-node ./node_modules/typeorm/cli.js migration:run
sudo systemctl start misskey.service
popd > /dev/null

sudo systemctl status --full --no-pager misskey.service

/home/misskey/wait-for-boot.sh

