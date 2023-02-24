defmodule Feder.Auth.Account do
  use Feder, :model

  @id_key :account_id

  @spec insert!(map) :: %Account.Entity{}
  def insert!(attrs) do
    %Account.Entity{}
    |> Account.Entity.changeset(attrs)
    |> Repo.insert!()
  end

  @spec get_by_email(String.t()) :: %Account.Entity{} | nil
  def get_by_email(email) do
    Repo.get_by(Account.Entity, email: email)
  end

  @spec id_key :: atom
  def id_key, do: @id_key
end
