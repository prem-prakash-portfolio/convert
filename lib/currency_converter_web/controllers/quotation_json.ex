defmodule CurrencyConverterWeb.QuotationJSON do
  alias CurrencyConverter.Conversions.Quotation

  @doc """
  Renders a list of quotations.
  """
  def index(%{quotations: quotations}) do
    %{data: for(quotation <- quotations, do: data(quotation))}
  end

  @doc """
  Renders a single quotation.
  """
  def show(%{quotation: quotation}) do
    %{data: data(quotation)}
  end

  defp data(%Quotation{} = quotation) do
    %{
      id: quotation.id,
      user_id: quotation.user_id,
      source_currency: quotation.source_currency,
      amount: quotation.amount,
      target_currency: quotation.target_currency,
      rate: quotation.rate,
      price: quotation.price,
      date: quotation.inserted_at
    }
  end
end
