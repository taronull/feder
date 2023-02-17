# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     Feder.Repo.insert!(%Feder.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

alias Feder.Repo
alias Feder.Auth.Account
alias Feder.Social.Profile
alias Feder.Social.List

Repo.insert!(%Account.Entity{email: "alice@example.com"})
Repo.insert!(%Profile.Entity{name: "Alice", account_id: 1})

Repo.insert!(%Account.Entity{email: "bob@example.com"})
Repo.insert!(%Profile.Entity{name: "Bob", account_id: 2})

Repo.insert!(%List.Entity{listing_profile: 1, listed_profile: 2})
