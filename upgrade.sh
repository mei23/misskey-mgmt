#!/bin/bash

SERVICE_BRANCH=$(cat ~/.service-branch)

pushd /home/misskey/live > /dev/null
git fetch --all
git checkout $SERVICE_BRANCH > /dev/null 2>&1
git status | grep "up to date"
if [[ $? -eq 0 ]]; then exit 0; fi
git reset --hard origin/$SERVICE_BRANCH
. ~/.nvm/nvm.sh install $(cat .node-version)
. ~/.nvm/nvm.sh use $(cat .node-version)

MSKY_UPGRADE_VERSION=$(git describe --tags --exact-match || echo "$(git describe --tags $(git rev-list --tags --max-count=1)) ($(git rev-parse HEAD))")
/home/misskey/note 【メンテナンス告知】当インスタンスは、今から約10分間 Misskey $MSKY_UPGRADE_VERSION へのアップデートを行います。その間、アクセスが円滑でないことがありますので、ご了承お願いいたします。

npm install -g npm
npm run clean
npm install
NODE_ENV=production npm run build
sudo systemctl stop misskey.service
sudo systemctl start misskey.service
popd > /dev/null

sudo systemctl status --full --no-pager misskey.service

/home/misskey/wait-for-boot.sh

/home/misskey/note 【メンテナンス終了】Misskey $MSKY_UPGRADE_VERSION へのアップデートが完了しました。

