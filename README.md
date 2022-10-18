# README

## Build Docker image
```docker buildx build --platform linux/arm64,linux/amd64 --tag lightningnetworkplus/lnpclient:v0.1.11 --output "type=registry" .```

## Required to run locally

* Ruby version: 3.0.1

* Rails version: 7.0.3.1

* No database

* No background jobs (ex. sidekiq)

* Requires a bitcoin lightning node (LND) that would simulate an umbrel node locally with the following environment variables

## Environmental variables

* MACAROON_PATH: "~/yourdevnode-admin.macaroon"

* LN_SERVER_URL: "yourdevnode.m.voltageapp.io:10009"

* CERTIFICATE_PATH: "~/yourdevnode.cert"

* RAILS_ENVIRONMENT: "development"

## Tests

* Tests are not implemented yet