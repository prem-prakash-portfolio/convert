# start ex_machina
{:ok, _} = Application.ensure_all_started(:ex_machina)

Mox.defmock(CurrencyConverterServices.ExchangeRatesAPI.Mock, for: CurrencyConverterServices.ExchangeRatesAPI)

config =
  :currency_converter
  |> Application.get_env(CurrencyConverterServices.ExchangeRatesAPI)
  |> Keyword.put(:adapter, CurrencyConverterServices.ExchangeRatesAPI.Mock)

Application.put_env(:currency_converter, CurrencyConverterServices.ExchangeRatesAPI, config)

ExUnit.configure(exclude: [:external_api])
ExUnit.start()
