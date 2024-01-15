defmodule CurrencyConverterServices.ExchangeRatesAPI.HTTPTest do
  use ExUnit.Case, async: true

  @moduletag :external_api

  alias CurrencyConverterServices.ExchangeRatesAPI.HTTP
  alias CurrencyConverterServices.ExchangeRatesAPI

  describe "tests" do
    test "when access key is invalid" do
      backup_access_key = get_access_key()
      put_access_key("")

      assert {:error, "Invalid response from ExchangeRates service"} == HTTP.get_rate("EUR", "BRL")

      put_access_key(backup_access_key)
    end

    test "success response" do
      assert {:ok, _rate} = HTTP.get_rate("EUR", "BRL")
    end

    test "with invalid currency" do
      assert {:error, "Invalid response from ExchangeRates service"} == HTTP.get_rate("AJO", "BRL")
    end

    defp get_access_key do
      :currency_converter |> Application.get_env(ExchangeRatesAPI) |> Keyword.get(:access_key)
    end

    defp put_access_key(access_key) do
      :currency_converter
      |> Application.get_env(ExchangeRatesAPI)
      |> Keyword.put(:access_key, access_key)
      |> tap(fn config -> Application.put_env(:currency_converter, ExchangeRatesAPI, config) end)
    end
  end
end
