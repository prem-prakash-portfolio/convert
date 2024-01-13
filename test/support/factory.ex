defmodule CurrencyConverter.Factory do
  @moduledoc """
  ExMachina factories agreggator
  """
  use ExMachina.Ecto, repo: CurrencyConverter.Repo

  # factories
  use CurrencyConverter.Conversions.QuotationFactory
end
