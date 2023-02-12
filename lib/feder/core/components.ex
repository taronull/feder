defmodule Feder.Core.Components do
  @moduledoc """
  Provides core UI components.

  Declare styles with utility classes.
  """
  use Feder, :html

  @doc """
  Renders a heading.
  """
  attr :level, :integer, default: 1, values: 1..6
  attr :class, :list, default: []
  attr :rest, :global

  slot :inner_block, required: true

  def heading(assigns) do
    ~H"""
    <.dynamic_tag 
      name={"h#{@level}"}
      class={[
        "text-xl md:text-2xl font-display font-semibold",
        @class
      ]}
      {@rest}
    >
      <%= render_slot(@inner_block) %>
    </.dynamic_tag>
    """
  end

  @doc """
  Renders a button.
  """
  attr :rest, :global, include: ~w(disabled form name value)

  slot :inner_block, required: true

  def button(assigns) do
    ~H"""
    <button
      class={[
        theme(),
        text_box(:double),
        tickle(),
        "font-display italic font-medium text-base cursor-default",
        "phx-submit-loading:opacity-75"
      ]}
      {@rest}
    >
      <%= render_slot(@inner_block) %>
    </button>
    """
  end

  @doc """
  Renders flash notices. Dismisses on click.
  """
  attr :class, :list, default: []
  attr :messages, :map
  attr :rest, :global

  def flash(assigns) do
    ~H"""
    <%= for {voice, message} <- @messages do %>
      <dialog
        onclick="this.close()"
        phx-click={JS.push("lv:clear-flash")}
        phx-value-key={voice}
        class={["bg-inherit p-0", @class]}
        {@rest}
        open
      >
        <div class={[
          theme(:invert),
          text_box(),
          tickle(),
          "group flex items-center justify-between gap-2"
        ]}>
          <p><%= message %></p>
          <Heroicons.x_mark
            mini
            aria-label={gettext("close")}
            class="h-4 stroke-current opacity-50 group-hover:opacity-75"
          />
        </div>
      </dialog>
    <% end %>
    """
  end

  @doc """
  Renders a modal.

  Open with `#showModal()`.
  It doesn't survive LiveSocket update.
  """
  attr :id, :string, required: true
  attr :class, :list, default: []

  slot :inner_block, required: true

  def modal(assigns) do
    ~H"""
    <dialog
      id={@id}
      class={["bg-inherit p-0", @class]}
      onclick="if (event.target == this) this.close()"
    >
      <.focus_wrap id={"#{@id}-focus-wrap"}>
        <div class={[
          theme(),
          box(),
          "mx-auto min-w-[16rem] w-1/2 max-w-prose",
          "grid justify-items-center gap-4",
          @class
        ]}>
          <%= render_slot(@inner_block) %>
        </div>
      </.focus_wrap>
    </dialog>
    """
  end

  @doc """
  Renders an input.
  Field association generates ID, name, and value out of schema.
  Otherwise, a name must be given.

  ## Examples

      <.input field={{f, :email}} type="email" />
      <.input name="my-input" errors={["oh no!"]} />
  """
  attr :field, :any, doc: "a %Phoenix.HTML.Form{}/field name tuple, for example: {f, :email}"
  attr :name, :string
  attr :class, :list, default: []
  attr :rest, :global, include: ~w(autocomplete disabled form max maxlength min minlength
                                   pattern placeholder readonly required size step)
  slot :inner_block

  def input(assigns) do
    with assigns <- maybe_field(assigns) do
    ~H"""
      <input
        id={assigns[:id] || @name}
        name={@name}
        value={assigns[:value]}
        phx-feedback-for={@name}
        class={[theme(), text_box(), "w-full", @class]}
        {@rest}
      />
    """
    end
  end

  def theme(mode \\ :normal)
  def theme(:normal), do: "bg-amber-50 text-dusk dark:bg-dusk dark:text-amber-50"
  def theme(:invert), do: "bg-dusk text-amber-50 dark:bg-amber-50 dark:text-dusk"

  def box, do: "block rounded border border-current px-4 py-4"

  def text_box(border \\ :single)
  def text_box(:single), do: "block rounded border border-current px-4 py-1"
  def text_box(:double), do: "block rounded border-[3px] border-double border-current px-4 py-1"

  def tickle, do: "hover:contrast-[.95] active:opacity-[.75]"

  defp maybe_field(%{field: {f, field}} = assigns) do
    assigns
    # TODO: Why `nil` here?
    # |> assign(field: nil)
    |> assign_new(:id, fn -> Phoenix.HTML.Form.input_id(f, field) end)
    |> assign_new(:name, fn -> Phoenix.HTML.Form.input_name(f, field) end)
    |> assign_new(:value, fn -> Phoenix.HTML.Form.input_value(f, field) end)
  end

  defp maybe_field(assigns), do: assigns
end
