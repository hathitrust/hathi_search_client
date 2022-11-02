[![Tests](https://github.com/hathitrust/search-client/actions/workflows/tests.yml/badge.svg)](https://github.com/hathitrust/search-client/actions/workflows/tests.yml)
[![Coverage Status](https://coveralls.io/repos/github/hathitrust/search-client/badge.svg?branch=main)](https://coveralls.io/github/hathitrust/search-client?branch=main)
[![Ruby Style Guide](https://img.shields.io/badge/code_style-standard-brightgreen.svg)](https://github.com/testdouble/standard)

# HathiTrust Search Client

This application allows users to search the HathiTrust catalog Solr index and
download metadata for the results.

## Getting Started

`docker-compose build web`
`docker-compose run --rm web bundle install`

## Running Tests

`docker-compose run --rm web bundle exec rspec`

## Using in Development

* Add your OpenID Connect issuer, client ID, and client secret in `.env`

* Add your Solr connection information in `.env` -- this could be a local Solr
  index running via https://github.com/hathitrust/hathitrust_catalog_indexer,
or something made available locally via SSH or Kubernetes port forwarding.

* Run `docker-compose up -d`

## Deploying in Production

namespace: search-client-testing

`tk apply kube/environments/testing`
