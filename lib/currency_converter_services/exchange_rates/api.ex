defmodule CurrencyConverterServices.ExchangeRatesAPI do
  @moduledoc """
  ExchangeRates (https://exchangeratesapi.io/) client
  """
  @type source_currency :: String.t()
  @type target_currency :: String.t()
  @type amount :: Decimal.t()
  @type rate :: Decimal.t()
  @type price :: Decimal.t()

  @callback get_rate(source_currency, target_currency) :: {:ok, rate} | {:error, any()}

  @spec get_rate(source_currency, target_currency) :: {:ok, rate} | {:error, any()}
  def get_rate(source_currency, target_currency), do: impl().get_rate(source_currency, target_currency)

  defp impl, do: Application.get_env(:currency_converter, __MODULE__, CurrencyConverterServices.ExchangeRatesAPI.HTTP)

  @spec convert(source_currency, target_currency, amount) :: {:ok, {rate, price}} | {:error, any()}
  def convert(source_currency, target_currency, amount) do
    with {:ok, rate} <- get_rate(source_currency, target_currency) do
      rate = Decimal.from_float(rate)
      price = Decimal.mult(amount, rate)
      {:ok, {rate, price}}
    end
  end
end
