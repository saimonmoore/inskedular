defmodule InskedularWeb.TeamController do
  use InskedularWeb, :controller

  alias Inskedular.Scheduling
  alias Inskedular.Scheduling.Projections.Team

  action_fallback InskedularWeb.FallbackController

  def index(conn, params) do
    teams = Scheduling.list_teams(params)
    IO.puts "[TeamController#index] teams: #{inspect(teams)} for: #{inspect(params)}"
    render(conn, "index.json", teams: teams)
  end

  def create(conn, team_params) do
    with {:ok, %Team{} = team} <- Scheduling.create_team(team_params) do
      conn
      |> put_status(:created)
      |> render("show.json", team: team)
    end
  end

  def update(conn, team_params) do
    with {:ok, %Team{} = team} <- Scheduling.update_team(team_params) do
      conn
      |> put_status(:ok)
      |> render("show.json", team: team)
    end
  end

  def delete(conn, %{ "id" => team_uuid }) do
    IO.puts "====> team_patrams: #{inspect(team_uuid)}"
    with {:ok } <- Scheduling.destroy_team(team_uuid) do
      conn
      |> put_status(:ok)
    end
  end
end
