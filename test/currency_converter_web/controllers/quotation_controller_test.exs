defmodule CurrencyConverterWeb.QuotationControllerTest do
  use CurrencyConverterWeb.ConnCase

  alias CurrencyConverter.Conversions.Quotation
  alias CurrencyConverter.Conversions
  alias CurrencyConverter.Repo

  import Mox
  setup :verify_on_exit!

  @create_attrs %{
    amount: "120.5",
    source_currency: "EUR",
    target_currency: "BRL",
    user_id: "some_user_id"
  }
  @invalid_attrs %{amount: nil, source_currency: nil, target_currency: nil, user_id: nil}

  setup %{conn: conn} do
    Repo.delete_all(Quotation)
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all conversions", %{conn: conn} do
      attrs = %{
        source_currency: "EUR",
        target_currency: "BRL",
        amount: "123.4",
        user_id: "some_user_id",
        rate: "12.3",
        price: "123123.2"
      }

      {:ok, _} = Conversions.create_quotation(attrs)
      conn = get(conn, ~p"/api/quotations", %{user_id: "some_user_id"})

      [
        %{
          "amount" => "123.4",
          "date" => _,
          "id" => _,
          "price" => "123123.2",
          "rate" => "12.3",
          "source_currency" => "EUR",
          "target_currency" => "BRL",
          "user_id" => "some_user_id"
        }
      ] = assert json_response(conn, 200)["data"]
    end
  end

  describe "create conversion" do
    test "renders conversion when data is valid", %{conn: conn} do
      expect(CurrencyConverterServices.ExchangeRatesAPI.Mock, :get_rate, fn "EUR", "BRL" -> {:ok, 5.322059} end)

      conn = post(conn, ~p"/api/quotations", @create_attrs)

      assert %{
               "amount" => "120.5",
               "price" => "641.3081095",
               "rate" => "5.322059",
               "source_currency" => "EUR",
               "target_currency" => "BRL",
               "user_id" => "some_user_id",
               "date" => _
             } = json_response(conn, 201)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, ~p"/api/quotations", conversion: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end
end
