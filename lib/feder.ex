defmodule Feder do
  @moduledoc """
  Defines interfaces for each module.

    use Feder, :live_view

  Provide module interface macros only.
  """

  def live do
    quote do
      use Phoenix.LiveView,
        layout: {Feder.Core.Layouts, :app}

      unquote(html())
      unquote(components())
    end
  end

  def component do
    quote do
      use Phoenix.LiveComponent
      unquote(components())
      unquote(html())
    end
  end

  def html do
    quote do
      use Phoenix.Component

      import Feder.Gettext

      alias Phoenix.LiveView.JS

      unquote(routes())
    end
  end

  def components do
    quote do
      import Feder.Core.Components
      import Feder.Auth.Components
      alias Feder.Social.ProfileImage
      alias Feder.Social.ProfileEditor
    end
  end

  def socket do
    quote do
      import Phoenix.LiveView
      import Phoenix.Component
    end
  end

  def conn do
    quote do
      use Phoenix.Controller, layouts: [html: Feder.Core.Layouts]

      import Feder.Gettext

      unquote(routes())
    end
  end

  def routes do
    quote do
      use Phoenix.VerifiedRoutes,
        endpoint: Feder.Endpoint,
        router: Feder.Router,
        statics: Feder.Endpoint.static_paths()
    end
  end

  def model do
    quote do
      alias Feder.Repo
      alias __MODULE__
    end
  end

  def entity do
    quote do
      use Ecto.Schema

      import Ecto.Changeset
      import Ecto.Query

      alias __MODULE__
    end
  end

  def conn_test do
    quote do
      use Feder.Core.Conn.Case, async: true
    end
  end

  def data_test do
    quote do
      use Feder.Core.Data.Case, async: true
    end
  end

  @doc """
  Dispatches an interface.
  """
  defmacro __using__(which) when is_atom(which) do
    apply(__MODULE__, which, [])
  end
end
