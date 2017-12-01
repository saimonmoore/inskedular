defmodule Inskedular.Scheduling.Projectors.Match do
  use Commanded.Projections.Ecto, name: "Scheduling.Projectors.Match",
                                  consistency: :strong
  use Inskedular.Support.Casting

  alias Inskedular.Scheduling.Events.MatchCreated
  alias Inskedular.Scheduling.Projections.Match

  project %MatchCreated{} = created do
    {:ok, start_date} = cast_datetime(created.start_date)
    {:ok, end_date} = cast_datetime(created.end_date)

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
end
