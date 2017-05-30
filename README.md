# Twittodon
Search specific tweet and post toot to mastodon

[![wercker status](https://app.wercker.com/status/17b86a545fd6c33053387b3fe3723796/m/master "wercker status")](https://app.wercker.com/project/byKey/17b86a545fd6c33053387b3fe3723796)

## Getting Started
Read [GETTING_STARTED.md](GETTING_STARTED.md)

## Rake tasks
You can run rake tasks on heroku via heroku cli

e.g.

* Local: `bundle exec rake perform`
* Heroku: `heroku run rake perform`

### `rake perform`
Search specific tweet and post toot to mastodon

#### Parameters
* `QUERY` : Twitter search query
  * same to https://twitter.com/search-home
* `MAX_COUNT` : Max tweet count (default is 10)

### `rake since_id:display`
Display all since_ids
(since_id is cache for each search query)

#### Example
```bash
$ bundle exec rake since_id:display
query='from:sue445 -RT #precure', since_id=869561044380786688
query='from:sue445 -RT', since_id=869557396930088966
```

### `rake since_id:delete`
Delete specific since_id

#### Parameters
* `QUERY` : Twitter search query

#### Example
```bash
$ QUERY="from:sue445 -RT" bundle exec rake since_id:delete
Deleted query='from:sue445 -RT', since_id=869557396930088966
```

### `rake since_id:delete_all`
Delete all since_ids

#### Example
```bash
$ bundle exec rake since_id:delete_all
Deleted query='from:sue445 -RT', since_id=869557396930088966
Deleted query='from:sue445 -RT #precure', since_id=869561044380786688
```

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
