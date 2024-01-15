defmodule CurrencyConverterWeb.QuotationController do
  use CurrencyConverterWeb, :controller

  use PhoenixSwagger

  alias CurrencyConverter.Conversions
  alias CurrencyConverter.Conversions.Quotation
  alias CurrencyConverterServices.ExchangeRatesAPI

  action_fallback CurrencyConverterWeb.FallbackController

  swagger_path :index do
    get("/quotations?user_id={user_id}")
    description("List quotations per user")
    produces("application/json")
    response(200, "OK", Schema.ref(:Quotations))

    parameters do
      user_id(:path, :string, "User Id", required: true, example: "some_user_id")
    end
  end

  def index(conn, %{"user_id" => user_id}) do
    quotations = Conversions.list_quotations_by_user_id(user_id)
    render(conn, :index, quotations: quotations)
  end

  swagger_path :create do
    post("/quotations")
    description("Request a quotation of currency conversion")
    produces("application/json")
    response(201, "OK", Schema.ref(:Quotation))

    parameter(:data, :body, Schema.ref(:QuotationRequestInput), "The quotation request",
      example: %{
        amount: "120.5",
        source_currency: "EUR",
        target_currency: "BRL",
        user_id: "some_user_id"
      }
    )
  end

  def create(conn, params) do
    with {:ok, attrs} <- normalize(params),
         {:ok, attrs} <- convert_and_merge(attrs),
         {:ok, %Quotation{} = quotation} <- Conversions.create_quotation(attrs) do
      conn
      |> put_status(:created)
      |> render(:show, quotation: quotation)
    end
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

  def swagger_definitions do
    %{
      QuotationRequestInput:
        swagger_schema do
          title("Quotation Request Input")
          description("Request a quotation of currency conversion")

          properties do
            amount(:decimal, "Amount", required: true)
            source_currency(:string, "Source Currency", required: true)
            target_currency(:string, "Target Currency", required: true)
            user_id(:string, "User id", required: true)
          end

          example(%{
            source_currency: "EUR",
            target_currency: "BRL",
            amount: "123.4",
            user_id: "some_user_id"
          })
        end,
      Quotation:
        swagger_schema do
          title("Quotation")
          description("A quotation of currency conversion")

          properties do
            price(:decimal, "Price", required: true)
            rate(:decimal, "Rate", required: true)
            amount(:decimal, "Amount", required: true)
            source_currency(:string, "Source Currency", required: true)
            target_currency(:string, "Target Currency", required: true)
            user_id(:string, "User id", required: true)
          end

          example(%{
            source_currency: "EUR",
            target_currency: "BRL",
            amount: "123.4",
            user_id: "some_user_id",
            rate: "2.0",
            price: "246.8"
          })
        end,
      Quotations:
        swagger_schema do
          title("Quotations")
          description("A collection of Quotations")
          type(:array)
          items(Schema.ref(:Quotation))
        end
    }
  end
end
