defmodule Feder.Auth.Account.Entity do
  use Feder, :entity

  schema "account" do
    field :email, :string

    has_many :access, Feder.Auth.Access.Entity, foreign_key: :account_id
    has_many :profile, Feder.Social.Profile.Entity, foreign_key: :account_id

    timestamps()
  end

  def changeset(account, attrs) do
    account
    |> cast(attrs, [:email])
    |> validate_required(:email)
    |> validate_format(:email, ~r/^[^\s]+@[^\s]+$/, message: "Please enter your email address")
    |> validate_length(:email, max: 255)
    |> unsafe_validate_unique(:email, Feder.Repo)
    |> unique_constraint(:email)
  end
end
