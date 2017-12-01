defmodule Inskedular.Scheduling.Events.MatchCreated do
  @derive [Poison.Encoder]
  defstruct [
    :match_uuid,
    :schedule_uuid,
    :local_team_uuid,
    :away_team_uuid,
    :match_number,
    :start_date,
    :end_date,
  ]
end
