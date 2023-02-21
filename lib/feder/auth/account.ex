defmodule Feder.Auth.Account do
  alias Feder.Repo
  alias __MODULE__

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

  @spec id_key :: :account_id
  def id_key, do: :account_id
end
