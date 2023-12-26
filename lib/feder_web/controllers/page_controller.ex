defmodule FederWeb.PageController do
  use FederWeb, :controller

  alias Feder.Waitlist

  def home(conn, _params) do
    # The home page is often custom made,
    # so skip the default app layout.
    changeset = Waitlist.change(%Waitlist{})
    render(conn, :home, layout: false, changeset: changeset)
  end

  def create(conn, %{"waitlist" => params}) do
    case Waitlist.create(params) do
      {:ok, waitlist} ->
        conn
        |> fetch_session()
        |> fetch_flash()
        |> put_flash(:info, "Joined as #{waitlist.email}")
        |> redirect(to: ~p"/")

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, :home, layout: false, changeset: changeset)
    end
  end
end
