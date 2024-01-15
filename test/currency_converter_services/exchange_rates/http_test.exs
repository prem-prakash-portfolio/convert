defmodule CurrencyConverterServices.ExchangeRatesAPI.HTTPTest do
  use ExUnit.Case, async: true

  @moduletag :external_api

  import ExUnit.CaptureLog

  alias CurrencyConverterServices.ExchangeRatesAPI.HTTP
  alias CurrencyConverterServices.ExchangeRatesAPI

  describe "CurrencyConverterServices.ExchangeRatesAPI.HTTP.get_rate" do
    test "when access key is invalid" do
      backup_access_key = get_access_key()
      put_access_key("")

      {result, log} = with_log(fn -> HTTP.get_rate("EUR", "BRL") end)
      assert {:error, "Invalid response from ExchangeRates service"} == result
      assert log =~ "CurrencyConverterServices.ExchangeRatesAPI.HTTP - Invalid response from"

      put_access_key(backup_access_key)
    end

    test "success response" do
      assert {:ok, _rate} = HTTP.get_rate("EUR", "BRL")
    end

    test "with invalid currency" do
      {result, log} = with_log(fn -> HTTP.get_rate("AJO", "BRL") end)
      assert {:error, "Invalid response from ExchangeRates service"} == result
      assert log =~ "CurrencyConverterServices.ExchangeRatesAPI.HTTP - Invalid response from"
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
