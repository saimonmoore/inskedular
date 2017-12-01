defmodule InskedularWeb.MatchView do
  use InskedularWeb, :view
  alias InskedularWeb.MatchView

  def render("index.json", %{matches: matches}) do
    %{data: render_many(matches, MatchView, "match.json")}
  end

  def render("show.json", %{match: match}) do
    %{data: render_one(match, MatchView, "match.json")}
  end

  def render("match.json", %{match: match}) do
    %{id: match.id,
      match_uuid: match.match_uuid,
      schedule_uuid: match.schedule_uuid,
      local_team_uuid: match.local_team_uuid,
      away_team_uuid: match.away_team_uuid,
      start_date: match.start_date,
      end_date: match.end_date,
      status: match.status,
      score_local_team: match.score_local_team,
      score_away_team: match.score_away_team,
      result: match.result,
      match_number: match.match_number}
  end
end
