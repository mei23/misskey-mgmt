#!/bin/bash

SERVICE_DOMAIN=$(cat ~/.service-domain)

/home/misskey/note 【メンテナンス告知】当インスタンスは、今から10秒後、約1分間 Misskey サービスの再起動を行います。その間、アクセスが円滑でないことがありますので、ご了承お願いいたします。
sleep 10s

sudo systemctl stop misskey.service
sudo systemctl start misskey.service
sudo systemctl status --full --no-pager misskey.service

while ! curl -sSLI https://$SERVICE_DOMAIN/.well-known/host-meta -o /dev/null -w '%{http_code}' | grep '200' | wc -l; do
  sleep 1s
done

/home/misskey/note 【メンテナンス終了】Misskey サービスの再起動が完了しました。

