defmodule Feder.Waitlist do
  alias Feder.Waitlist
  use Ecto.Schema
  import Ecto.Changeset

  schema "waitlist" do
    field :email, :string

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(waitlist, attrs) do
    waitlist
    |> cast(attrs, [:email])
    |> validate_required([:email])
    |> validate_format(:email, ~r/^[^\s]+@[^\s]+$/, message: "Please enter your email address")
    |> validate_length(:email, max: 255)
    |> unsafe_validate_unique(:email, Feder.Repo)
    |> unique_constraint(:email)
  end

  def create(attrs) do
    %Waitlist{}
    |> changeset(attrs)
    |> Feder.Repo.insert()
  end

  def change(%Waitlist{} = waitlist, attrs \\ %{}) do
    Waitlist.changeset(waitlist, attrs)
  end
end
