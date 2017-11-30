defmodule InskedularWeb.TeamController do
  use InskedularWeb, :controller

  alias Inskedular.Scheduling
  alias Inskedular.Scheduling.Projections.Team

  action_fallback InskedularWeb.FallbackController

  def index(conn, params) do
    teams = Scheduling.list_teams(params)
    render(conn, "index.json", teams: teams)
  end

  def create(conn, team_params) do
    with {:ok, %Team{} = team} <- Scheduling.create_team(team_params) do
      conn
      |> put_status(:created)
      |> render("show.json", team: team)
    end
  end
end
