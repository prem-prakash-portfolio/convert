defmodule CurrencyConverterServices.ExchangeRatesAPI.HTTPTest do
  use ExUnit.Case, async: true

  @moduletag :external_api

  alias CurrencyConverterServices.ExchangeRatesAPI.HTTP
  alias CurrencyConverterServices.ExchangeRatesAPI

  describe "tests" do
    test "when access key is invalid" do
      :currency_converter
      |> Application.get_env(ExchangeRatesAPI)
      |> Keyword.put(:access_key, "")
      |> tap(fn config -> Application.put_env(:currency_converter, ExchangeRatesAPI, config) end)

      assert {:error, "Invalid response from ExchangeRates service"} == HTTP.get_rate("EUR", "BRL")
    end

    test "success response" do
      assert {:ok, _rate} = HTTP.get_rate("EUR", "BRL")
    end

    test "with invalid currency" do
      assert {:error, "Invalid response from ExchangeRates service"} == HTTP.get_rate("AJO", "BRL")
    end
  end
end
