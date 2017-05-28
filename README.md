# Twittodon
[![wercker status](https://app.wercker.com/status/17b86a545fd6c33053387b3fe3723796/m/master "wercker status")](https://app.wercker.com/project/byKey/17b86a545fd6c33053387b3fe3723796)

## Requirements
* Ruby
* Redis

## Development
### Setup
```bash
bundle install
cp .env.example .env
```

## Heroku
### Setup
```sh
heroku addons:add heroku-redis
heroku addons:add papertrail
heroku addons:add rollbar
heroku addons:add scheduler

heroku config:add ENVIRONMENT=production
heroku config:add TWITTER_CONSUMER_KEY=XXXXXXXXXXXXXX
heroku config:add TWITTER_CONSUMER_SECRET=XXXXXXXXXXXXXX
heroku config:add TWITTER_ACCESS_TOKEN=XXXXXXXXXXXXXX
heroku config:add TWITTER_ACCESS_TOKEN_SECRET=XXXXXXXXXXXXXX
heroku config:add MASTODON_URL=https://mastodon.example.com
heroku config:add MASTODON_ACCESS_TOKEN=XXXXXXXXXXXXXX
```
