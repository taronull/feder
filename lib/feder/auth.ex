defmodule Feder.Auth do
  use Feder, :html

  alias __MODULE__.Access

  @doc """
  Sends an email with an access token to `account`.
  """
  def mail_access(email) do
    with access <- Access.grant(email) do
      Feder.Mailer.post(email, %{
        title: "Sign in with your email",
        body: """
        Sign in with your account by visiting the URL below:
        #{url(~p"/?#{Access.token_key()}=") <> Base.url_encode64(access.token)}
        If you didn't request for this, please ignore this.
        """
      })
    end
  end
end
