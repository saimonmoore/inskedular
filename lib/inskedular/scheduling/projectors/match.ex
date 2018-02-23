defmodule Inskedular.Scheduling.Projectors.Match do
  use Commanded.Projections.Ecto, name: "Scheduling.Projectors.Match",
                                  consistency: :strong
  use Inskedular.Support.Casting

  alias Inskedular.Scheduling.Events.{MatchCreated,MatchUpdated,MatchDestroyed}
  alias Inskedular.Scheduling.Projections.Match

  project %MatchCreated{} = created do
    {:ok, start_date} = cast_datetime(created.start_date)
    {:ok, end_date} = cast_datetime(created.end_date)

    IO.puts "[Projector.Match#project] =======> created: #{inspect(created)} "
    Ecto.Multi.insert(multi, :match, %Match{
      uuid: created.match_uuid,
      schedule_uuid: created.schedule_uuid,
      match_number: created.match_number,
      local_team_uuid: created.local_team_uuid,
      away_team_uuid: created.away_team_uuid,
      start_date: start_date,
      end_date: end_date,
    })
  end

  project %MatchUpdated{} = updated do
    IO.puts "[Projector.Match#project updated] =======> updated: #{inspect(updated)} "
    Ecto.Multi.update_all(multi, :match, match_query(updated.match_uuid), set: [
      status: updated.status,
      score_local_team: updated.score_local_team,
      score_away_team: updated.score_away_team,
      result: updated.result,
    ])
  end

  project %MatchDestroyed{} = destroyed do
    IO.puts "[Projector.Match#project destroyed] =======> destroyed: #{inspect(destroyed)} "
    Ecto.Multi.update_all(multi, :match, match_query(destroyed.match_uuid), set: [
      status: destroyed.status,
    ])
  end

  defp match_query(match_uuid) do
    from(a in Match, where: a.uuid == ^match_uuid)
  end
end
