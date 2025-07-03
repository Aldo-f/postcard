#!/usr/bin/env bash
# exit on error
set -o errexit

bundle config set --local force_ruby_platform false
bundle install
bundle exec rake assets:precompile
bundle exec rake assets:clean
#bundle exec rake db:migrate
bundle exec rake sitemap:refresh:no_ping

npm install

curl -g "https://api.honeybadger.io/v1/deploys?deploy[environment]=production&api_key=hbp_80nHltnYxlL3kfchmAYlpDRZqs60Ks0xc1WC"