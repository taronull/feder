alias Feder.Repo
alias Feder.Auth.Account
alias Feder.Social.Profile
alias Feder.Social.List

Repo.insert!(%Account.Entity{email: "alice@example.com"})
Repo.insert!(%Profile.Entity{name: "Alice", account_id: 1})

Repo.insert!(%Account.Entity{email: "bob@example.com"})
Repo.insert!(%Profile.Entity{name: "Bob", account_id: 2})

Repo.insert!(%List.Entity{listing_profile: 1, listed_profile: 2})
