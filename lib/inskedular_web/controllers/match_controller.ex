defmodule InskedularWeb.MatchController do
  use InskedularWeb, :controller

  alias Inskedular.Scheduling
  alias Inskedular.Scheduling.Projections.Match

  action_fallback InskedularWeb.FallbackController

  def index(conn, params) do
    matches = Scheduling.list_matches(params)
    render(conn, "index.json", matches: matches)
  end

  def update(conn, match_params) do
    with {:ok, %Match{} = match} <- Scheduling.update_match(match_params) do
      conn
      |> put_status(:ok)
      |> render("show.json", match: match)
    end
  end
end
