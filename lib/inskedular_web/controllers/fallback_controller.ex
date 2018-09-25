defmodule InskedularWeb.FallbackController do
  @moduledoc """
  Translates controller action results into valid `Plug.Conn` responses.

  See `Phoenix.Controller.action_fallback/1` for more details.
  """
  use InskedularWeb, :controller

  def call(conn, {:error, :validation_failure, errors}) do
    conn
    |> put_status(:unprocessable_entity)
    |> render(InskedularWeb.ValidationView, "error.json", errors: errors)
  end

  def call(conn, {:name, errors}) do
    conn
    |> put_status(:unprocessable_entity)
    |> render(InskedularWeb.ValidationView, "error.json", errors: errors)
  end

  def call(conn, {:error, :not_found}) do
    conn
    |> put_status(:not_found)
    |> render(InskedularWeb.ErrorView, :"404")
  end
end
