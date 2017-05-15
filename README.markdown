# Fadeaway Website

Website for the Fadeaway application.

## Setup

Install the dependencies.

    bundle install

Create the database and seed records.

    bundle exec rake db:setup

## Development

Before pushing changes, check the code. This will run the tests, including code
coverage, examine the code style, and examine the SCSS style.

    bundle exec rake check

## Deployment

To deploy the `master` branch:

    bundle exec cap [local|remote] deploy

To deploy a `custom-branch` to production:

    BRANCH=custom-branch bundle exec cap [local|remote] deploy
