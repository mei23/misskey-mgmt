#!/bin/bash

SERVICE_DOMAIN=$(cat ~/.service-domain)

while ! curl -sSLI -X POST https://suki.tsuki.network/api/meta | head -n1 | grep "200"; do
  sleep 1s
done

