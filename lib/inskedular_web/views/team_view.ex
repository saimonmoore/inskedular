defmodule InskedularWeb.TeamView do
  use InskedularWeb, :view
  alias InskedularWeb.TeamView

  def render("index.json", %{teams: teams}) do
    render_many(teams, TeamView, "team.json")
  end

  def render("show.json", %{team: team}) do
    render_one(team, TeamView, "team.json")
  end

  def render("team.json", %{team: team}) do
    %{uuid: team.uuid,
      name: team.name,
      schedule_uuid: team.schedule_uuid}
  end
end
