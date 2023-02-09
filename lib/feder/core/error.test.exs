defmodule Feder.Core.Error.Test do
  use ExUnit.Case, async: true

  import Phoenix.Template, only: [render_to_string: 4]

  describe "HTML error" do
    test "renders 404.html" do
      assert render_to_string(Feder.Core.Error, "404", "html", []) ==
               "404 Not Found"
    end

    test "renders 500.html" do
      assert render_to_string(Feder.Core.Error, "500", "html", []) ==
               "500 Internal Server Error"
    end
  end

  describe "JSON error" do
    test "renders 404.json" do
      assert Feder.Core.Error.render("404.json", %{}) ==
               %{error: %{code: "404", message: "Not Found"}}
    end

    test "renders 500.json" do
      assert Feder.Core.Error.render("500.json", %{}) ==
               %{error: %{code: "500", message: "Internal Server Error"}}
    end
  end
end
