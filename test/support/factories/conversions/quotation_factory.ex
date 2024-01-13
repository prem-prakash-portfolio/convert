defmodule CurrencyConverter.Conversions.QuotationFactory do
  @moduledoc """
  Quotation factory
  """
  defmacro __using__(_opts) do
    quote do
      def quotation_factory do
        %CurrencyConverter.Conversions.Quotation{
          rate: 5.0234,
          amount: 10,
          source_currency: "EUR",
          target_currency: "BRL",
          price: 50.234,
          user_id: sequence(:user_id, &"#{&1}")
        }
      end
    end
  end
end
