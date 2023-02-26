defmodule Feder.Core.Layouts do
  use Feder, :html
  use Feder, :components

  import Phoenix.Controller, only: [get_csrf_token: 0]

  def app(assigns) do
    ~H"""
    <header class={[
      "sticky top-0 px-6 py-4",
      "flex items-center justify-between"
    ]}>
      <div class="flex items-center gap-4">
        <.link href={~p"/"}>
          <img class="h-8" src="/images/symbol.svg" />
        </.link>
        <Heroicons.cloud
          class="h-4 animate-pulse"
          id="connecting"
          phx-disconnected={JS.show(to: "#connecting")}
          phx-connected={JS.hide(to: "#connecting")}
        />
      </div>
      <.link href={~p"/account"}>
        <.live_component
          :if={@account_id}
          module={ProfileImage}
          id={@account_id}
          account_id={@account_id}
        />
      </.link>
    </header>

    <.flash messages={@flash} class={["fixed top-16 inset-x-8"]} />

    <main class="mx-auto px-8 max-w-[32rem]">
      <%= @inner_content %>
    </main>
    """
  end

  def root(assigns) do
    ~H"""
    <!DOCTYPE html>
    <html lang="en">
      <head>
        <meta charset="utf-8" />
        <meta name="viewport" content="width=device-width, initial-scale=1" />
        <meta name="csrf-token" content={get_csrf_token()} />
        <.live_title>
          <%= assigns[:page_title] || "Feder" %>
        </.live_title>
        <link phx-track-static rel="stylesheet" href={~p"/assets/app.css"} />
        <script defer phx-track-static type="text/javascript" src={~p"/assets/app.js"}>
        </script>
        <script src="https://accounts.google.com/gsi/client" async defer>
        </script>
        <meta name="application-name" content="Feder" />
        <meta name="apple-mobile-web-app-title" content="Feder" />
        <meta name="theme-color" media="(prefers-color-scheme: dark)" content="#036" />
        <meta name="theme-color" media="(prefers-color-scheme: light)" content="#FFFBEB" />
        <meta name="msapplication-TileColor" content="#036" />
        <meta name="msapplication-config" content="/browserconfig.xml" />
        <link rel="manifest" href="/site.webmanifest" />
        <link rel="shortcut icon" href="/favicons/favicon.ico" />
        <link rel="icon" type="image/png" sizes="32x32" href="/favicons/favicon-32x32.png" />
        <link rel="icon" type="image/png" sizes="16x16" href="/favicons/favicon-16x16.png" />
        <link rel="apple-touch-icon" sizes="180x180" href="/favicons/apple-touch-icon.png" />
        <link rel="mask-icon" href="/favicons/safari-pinned-tab.svg" color="#036" />
      </head>
      <body class={[theme(), "md:text-lg font-body antialiased"]}>
        <%= @inner_content %>
      </body>
    </html>
    """
  end
end
