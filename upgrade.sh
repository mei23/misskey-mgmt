#!/bin/bash

SERVICE_BRANCH=$(cat ~/.service-branch)

export NODE_ENV=production
pushd /home/misskey/live > /dev/null
git fetch --all --tags --prune --prune-tags
git checkout $SERVICE_BRANCH > /dev/null 2>&1
git status | grep "up to date"
if [[ $? -eq 0 ]]; then exit 0; fi
git reset --hard origin/$SERVICE_BRANCH
. ~/.nvm/nvm.sh install $(cat .node-version)
. ~/.nvm/nvm.sh use $(cat .node-version)

GIT_CURRENT_COMMIT=$(git rev-parse HEAD)
MSKY_UPGRADE_VERSION=$(git describe --tags --exact-match || echo "$(git describe --tags $(git rev-list --tags --max-count=1)) (${GIT_CURRENT_COMMIT:0:8})")
/home/misskey/note 【メンテナンス告知】当インスタンスは、今から約10分間 Misskey $MSKY_UPGRADE_VERSION へのアップデートを行います。その間、アクセスが円滑でないことがありますので、ご了承お願いいたします。

npm install -g npm
npm install -g ts-node web-push
npm run clean
npm install
npm run build
sudo systemctl stop misskey.service
ts-node ./node_modules/typeorm/cli.js migration:run
sudo systemctl start misskey.service
popd > /dev/null

sudo systemctl status --full --no-pager misskey.service

/home/misskey/wait-for-boot.sh

/home/misskey/note 【メンテナンス終了】Misskey $MSKY_UPGRADE_VERSION へのアップデートが完了しました。

