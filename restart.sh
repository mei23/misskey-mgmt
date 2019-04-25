#!/bin/bash

sudo systemctl stop misskey.service
sudo systemctl start misskey.service
sudo systemctl status --full --no-pager misskey.service

