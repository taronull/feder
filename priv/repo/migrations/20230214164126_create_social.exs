defmodule Feder.Repo.Migrations.CreateSocial do
  use Ecto.Migration

  def change do
    create table(:profile, primary_key: false) do
      add :id, :identity, primary_key: true
      add :account_id, references(:account), null: false
      add :name, :string, null: false
      add :image, :string

      timestamps()
    end

    create table(:list, primary_key: false) do
      add :listing_profile,
          references(:profile, on_delete: :delete_all),
          primary_key: true

      add :listed_profile,
          references(:profile, on_delete: :delete_all),
          primary_key: true
    end
  end
end