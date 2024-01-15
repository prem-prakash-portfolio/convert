[![Coverage Status](https://coveralls.io/repos/github/prem-prakash-portfolio/currency-converter/badge.svg?branch=main)](https://coveralls.io/github/prem-prakash-portfolio/currency-converter?branch=main)

# CurrencyConverter

[https://jaya-prakash-currency-converter.fly.dev/api/swagger/index.html](https://jaya-prakash-currency-converter.fly.dev/api/swagger/index.html)

## Development

To start your Phoenix server:

  * Run `mix setup` to install and setup dependencies
  * Start Phoenix endpoint with `mix phx.server` or inside IEx with `iex -S mix phx.server`

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.

Ready to run in production? Please [check our deployment guides](https://hexdocs.pm/phoenix/deployment.html).

## CI/CD

 - Uses Github Actions
 - Need to config Secrets:
   - `FLY_API_TOKEN` for deploy on fly.io
   - `EXCHANGE_RATES_ACCESS_KEY` for test exchangerates api

## Deploy your own version

 - Clone the repo

 - Get a free API Access Key for [ExchangeRates](https://exchangeratesapi.io/).

 -  Follow the steps:

1. `$ curl -L https://fly.io/install.sh | sh`
2. `$ fly auth signup`
3. `$ fly launch --copy-config --vm-memory 256 --yes --now`
4. `$ fly secrets set EXCHANGE_RATES_ACCESS_KEY="your ExchangeRates API access key"`
5. `$ fly deploy`

See more about how to deploy on [Fly.io](https://hexdocs.pm/phoenix/fly.html).
