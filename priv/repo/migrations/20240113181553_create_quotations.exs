defmodule CurrencyConverter.Repo.Migrations.CreateQuotations do
  use Ecto.Migration

  def change do
    create table(:quotations) do
      add :user_id, :string
      add :source_currency, :string
      add :amount, :decimal
      add :target_currency, :string
      add :rate, :decimal
      add :price, :decimal

      timestamps(type: :utc_datetime, updated_at: false)
    end
  end
end
