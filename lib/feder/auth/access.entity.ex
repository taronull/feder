defmodule Feder.Auth.Access.Entity do
  use Feder, :entity

  schema "access" do
    field :token, :binary

    belongs_to :account, Feder.Auth.Account.Entity, foreign_key: :account_id

    timestamps()
  end

  def changeset(access, attrs) do
    access
    |> cast(attrs, [:token, :account_id])
    |> ensure(:token)
    |> validate_required([:token, :account_id])
    |> foreign_key_constraint(:account_id)
    |> unique_constraint(:token)
  end

  def query_by_token(token) do
    from a in Entity, where: a.token == ^token
  end

  def query_account_id_by_token(token) do
    from a in query_by_token(token),
      join: account in assoc(a, :account),
      where: a.inserted_at > ago(365, "day"),
      select: account.id
  end

  defp ensure(changeset, :token) do
    case get_field(changeset, :token) do
      nil -> put_change(changeset, :token, :crypto.strong_rand_bytes(32))
      _ -> changeset
    end
  end
end
