# stonks-api

Ruby API made for fun and stonks.

## Requirements:

1. Ruby.
1. A Redis instance.
1. An IEX Cloud API token. Create a free [IEX Cloud](https://iexcloud.io/) account to get one.

## Instructions:

1. Make sure your Redis instance is up and running.
1. Create an environment variable called `TOKEN` and assign your IEX Cloud API token.
1. From the repo folder run `bundle install` and then `rackup`on a terminal.

```bash
bundle install
rackup
```

Your API should be up and running :)
