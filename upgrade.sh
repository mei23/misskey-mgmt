#!/bin/bash

SERVICE_BRANCH=$(cat ~/.service-branch)

export NODE_ENV=production
pushd /home/misskey/live > /dev/null
git fetch --all --tags --prune --prune-tags
git checkout $SERVICE_BRANCH > /dev/null 2>&1
git status | grep "up to date"
if [[ $? -eq 0 ]]; then exit 0; fi
git reset --hard origin/$SERVICE_BRANCH
echo "v14" > .node-version
. ~/.nvm/nvm.sh
nvm install $(cat .node-version)
nvm use $(cat .node-version)

GIT_CURRENT_COMMIT=$(git rev-parse HEAD)
MSKY_UPGRADE_VERSION=$(git describe --tags --exact-match || echo "$(grep 'version' package.json | awk -F\" '{ print $4 }') (${GIT_CURRENT_COMMIT:0:8})")
/home/misskey/note 【メンテナンス告知】当インスタンスは、今から約10分間 Misskey $MSKY_UPGRADE_VERSION へのアップデートを行います。その間、アクセスが円滑でないことがありますので、ご了承お願いいたします。
git describe --tags --exact-match || sed -i -re '0,/"version":\s+".+"/ s/("version":\s+".+)"/\1-'"${GIT_CURRENT_COMMIT:0:8}"'"/' package.json

npm install -g npm
npx yarn install --prod=false
npm run clean
npm run build
sudo systemctl stop misskey.service
npm run migrate
sudo systemctl start misskey.service
popd > /dev/null

sudo systemctl status --full --no-pager misskey.service

/home/misskey/wait-for-boot.sh

/home/misskey/note 【メンテナンス終了】Misskey $MSKY_UPGRADE_VERSION へのアップデートが完了しました。
