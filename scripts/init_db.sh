#!/bin/sh

echo 'db:migrate:reset'
bin/rails db:migrate:reset
bin/rails db:migrate:reset RAILS_ENV=test

echo 'db:fixtures:load'
bin/rails db:fixtures:load FIXTURES_PATH=./db/fixtures
bin/rails db:fixtures:load FIXTURES_PATH=./db/fixtures RAILS_ENV=test

echo 'db:seed for development'
bin/rails db:seed
