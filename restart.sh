#!/bin/bash

/home/misskey/note 【メンテナンス告知】当インスタンスは、今から10秒後、約1分間 Misskey サービスの再起動を行います。その間、アクセスが円滑でないことがありますので、ご了承お願いいたします。

echo
echo wait 10 seconds ...
sleep 10s

echo restart misskey.service
sudo systemctl stop misskey.service
sudo systemctl start misskey.service
sudo systemctl status --full --no-pager misskey.service

echo wait for misskey.service bootup ...
/home/misskey/wait-for-boot.sh

/home/misskey/note 【メンテナンス終了】Misskey サービスの再起動が完了しました。

