defmodule Feder.WaitlistTest do
  use Feder.DataCase, async: true

  alias Feder.Waitlist

  test "insert/1" do
    email = "alice@example.com"

    Waitlist.insert(%{email: email})

    entry = Repo.get_by(Waitlist, email: email)

    assert entry.email == email
  end
end
