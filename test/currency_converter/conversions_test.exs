defmodule CurrencyConverter.ConversionsTest do
  use CurrencyConverter.DataCase

  alias CurrencyConverter.Conversions

  describe "conversions" do
    alias CurrencyConverter.Conversions.Quotation

    test "list_quotations_by_user_id/1 returns all conversions" do
      quotation = insert(:quotation)
      assert Conversions.list_quotations_by_user_id(quotation.user_id) == [quotation]
    end

    test "create_quotation/1 with valid data creates a conversion" do
      valid_attrs = %{
        price: "120.5",
        rate: "120.5",
        amount: "120.5",
        source_currency: "some source_currency",
        target_currency: "some target_currency",
        user_id: "some user_id"
      }

      assert {:ok, %Quotation{} = conversion} = Conversions.create_quotation(valid_attrs)
      assert conversion.price == Decimal.new("120.5")
      assert conversion.rate == Decimal.new("120.5")
      assert conversion.amount == Decimal.new("120.5")
      assert conversion.source_currency == "some source_currency"
      assert conversion.target_currency == "some target_currency"
      assert conversion.user_id == "some user_id"
    end
  end
end
