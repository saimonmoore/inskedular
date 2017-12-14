defmodule Inskedular.Scheduling.Events.TeamDestroyed do
  @derive [Poison.Encoder]
  defstruct [
    :team_uuid,
  ]
end
