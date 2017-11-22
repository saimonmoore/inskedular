defmodule InskedularWeb.PageController do
  use InskedularWeb, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end
end
