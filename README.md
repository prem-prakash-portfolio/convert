# CurrencyConverter

## Deployment

Get a free API Access Key for [ExchangeRates](https://exchangeratesapi.io/).

Simple steps:

1. `$ curl -L https://fly.io/install.sh | sh`
2. `$ fly auth signup`
5. `$ fly launch --copy-config --vm-memory 256 --yes --now`
8. `$ fly secrets set EXCHANGE_RATES_ACCESS_KEY="your ExchangeRates API access key"`

See more about how to deploy on [Fly.io](https://hexdocs.pm/phoenix/fly.html).

## Development

To start your Phoenix server:

  * Run `mix setup` to install and setup dependencies
  * Start Phoenix endpoint with `mix phx.server` or inside IEx with `iex -S mix phx.server`

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.

Ready to run in production? Please [check our deployment guides](https://hexdocs.pm/phoenix/deployment.html).
