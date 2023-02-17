defmodule Feder.Repo.Migrations.CreateAuth do
  use Ecto.Migration

  def change do
    create table(:account, primary_key: false) do
      add :id, :identity, primary_key: true

      timestamps()
    end

    execute """
    create collation case_insensitive (
      provider = icu,
      locale = 'und-u-ks-level2',
      deterministic = false
    );
    """

    execute """
    alter table "account" 
      add column "email" varchar(255) collate case_insensitive not null;
    """

    create unique_index(:account, [:email])

    create table(:access, primary_key: false) do
      add :id, :identity, primary_key: true
      add :account_id, references(:account, on_delete: :delete_all), null: false
      add :token, :binary, null: false

      timestamps()
    end

    create index(:access, [:account_id])
    create unique_index(:access, [:token])
  end
end
