defmodule CurrencyConverter.Conversions.Quotation do
  @moduledoc """
  Quotation schema
  """
  use Ecto.Schema
  import Ecto.Changeset

  schema "quotations" do
    field :price, :decimal
    field :rate, :decimal
    field :amount, :decimal
    field :source_currency, :string
    field :target_currency, :string
    field :user_id, :string

    timestamps(type: :utc_datetime, updated_at: false)
  end

  @doc false
  def changeset(quotation, attrs) do
    quotation
    |> cast(attrs, [:user_id, :source_currency, :amount, :target_currency, :rate, :price])
    |> validate_required([:user_id, :source_currency, :amount, :target_currency, :rate, :price])
  end
end
