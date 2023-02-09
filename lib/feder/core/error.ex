defmodule Feder.Core.Error do
  def render(<<code::binary-3>> <> ".html" = template, _assigns) do
    code <> " " <> message(template)
  end

  def render(<<code::binary-3>> <> ".json" = template, _assigns) do
    %{error: %{code: code, message: message(template)}}
  end

  def message(template) do
    Phoenix.Controller.status_message_from_template(template)
  end
end
