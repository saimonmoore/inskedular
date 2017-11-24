defmodule InskedularWeb.ValidationView do
  use InskedularWeb, :view

  def render("error.json", %{errors: errors}) do
    %{errors: errors}
  end
end
