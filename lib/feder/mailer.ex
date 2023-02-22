defmodule Feder.Mailer do
  use Swoosh.Mailer, otp_app: :feder

  import Swoosh.Email

  @sender {"Feder", "info@feder.is"}

  @type letter :: %{
          title: String.t(),
          body: String.t()
        }

  @spec post(String.t(), letter) :: {:ok, term} | {:error, term}
  def post(recipient, letter) do
    new()
    |> to(recipient)
    |> from(@sender)
    |> subject(letter.title)
    |> text_body(letter.body)
    |> deliver()
  end
end
