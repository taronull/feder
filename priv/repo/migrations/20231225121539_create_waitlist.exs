defmodule Feder.Repo.Migrations.CreateWaitlist do
  use Ecto.Migration

  def change do
    create table(:waitlist) do
      add :email, :string

      timestamps(type: :utc_datetime)
    end
  end
end
