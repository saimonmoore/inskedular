defmodule Inskedular.Scheduling.Events.MatchUpdated do
  @derive [Poison.Encoder]
  defstruct [
    :match_uuid,
    :status,
    :score_local_team,
    :score_away_team,
    :result,
  ]
end
