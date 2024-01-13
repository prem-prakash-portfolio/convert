defmodule CurrencyConverterServices.ExchangeRatesAPI.HTTP do
  @moduledoc """
  HTTP implementation for exchangerates.io currency converter service API
  """
  @behaviour CurrencyConverterServices.ExchangeRatesAPI

  @impl true
  @spec get_rate(String.t(), String.t()) :: {:ok, Decimal.t()} | {:error, any()}
  def get_rate(source_currency, target_currency) do
    url = build_url(source_currency)
    options = [connect_options: [timeout: 500]]

    case Req.get!(url, options) do
      %Req.Response{body: body = %{"success" => true}} -> process_success(body, target_currency)
      %Req.Response{body: body = %{"success" => false}} -> process_error(body)
    end
  end

  defp build_url(source_currency) do
    "http://api.exchangeratesapi.io/latest?base=#{source_currency}&access_key=#{access_key()}"
  end

  defp access_key do
    :currency_converter
    |> Application.fetch_env!(CurrencyConverterServices.ExchangeRatesAPI)
    |> Keyword.fetch!(:access_key)
  end

  defp process_success(body, target_currency) do
    rate = body |> Map.fetch!("rates") |> Map.fetch!(target_currency)
    {:ok, rate}
  end

  defp process_error(_body) do
    # log("Invalid response from ExchangeRates service", body)
    {:error, "Invalid response from ExchangeRates service"}
  end
end
