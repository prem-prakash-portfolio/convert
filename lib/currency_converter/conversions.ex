defmodule CurrencyConverter.Conversions do
  @moduledoc """
  The Conversions context.
  """

  import Ecto.Query, warn: false
  alias CurrencyConverter.Repo

  alias CurrencyConverter.Conversions.Quotation

  @doc """
  Returns the list of quotations.

  ## Examples

      iex> list_quotations_by_user_id(user_id)
      [%Quotation{}, ...]

  """
  def list_quotations_by_user_id(user_id) do
    query = from(c in Quotation, where: c.user_id == ^user_id)
    Repo.all(query)
  end

  @doc """
  Creates a quotation.

  ## Examples

      iex> create_quotation(%{field: value})
      {:ok, %Quotation{}}

      iex> create_quotation(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_quotation(attrs \\ %{}) do
    %Quotation{}
    |> Quotation.changeset(attrs)
    |> Repo.insert()
  end
end
