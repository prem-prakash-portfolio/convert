defmodule CurrencyConverter.Factory do
  use ExMachina.Ecto, repo: CurrencyConverter.Repo
  use CurrencyConverter.Conversions.QuotationFactory
end
