defmodule CurrencyConverterWeb.QuotationController do
  use CurrencyConverterWeb, :controller

  alias CurrencyConverter.Conversions
  alias CurrencyConverter.Conversions.Quotation
  alias CurrencyConverterServices.ExchangeRatesAPI

  action_fallback CurrencyConverterWeb.FallbackController

  def index(conn, %{"user_id" => user_id}) do
    quotations = Conversions.list_quotations_by_user_id(user_id)
    render(conn, :index, quotations: quotations)
  end

  def create(conn, params) do
    with {:ok, %Quotation{} = quotation} <- do_create(params) do
      conn
      |> put_status(:created)
      |> render(:show, quotation: quotation)
    end
  end

  defp do_create(params) do
    Repo.transact(fn ->
      with {:ok, attrs} <- normalize(params),
           {:ok, attrs} <- convert_and_merge(attrs) do
        Conversions.create_quotation(attrs)
      end
    end)
  end

  defp convert_and_merge(attrs) do
    with {:ok, {rate, price}} <- ExchangeRatesAPI.convert(attrs.source_currency, attrs.target_currency, attrs.amount) do
      {:ok, Map.merge(attrs, %{rate: rate, price: price})}
    end
  end

  defp normalize(params) do
    types = %{
      amount: :decimal,
      source_currency: :string,
      target_currency: :string,
      user_id: :string
    }

    {%{}, types}
    |> Ecto.Changeset.cast(params, Map.keys(types))
    |> Ecto.Changeset.validate_required([:amount, :source_currency, :target_currency, :user_id])
    |> Ecto.Changeset.apply_action(:insert)
  end
end
