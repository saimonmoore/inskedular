defmodule Inskedular.Scheduling.Events.TeamCreated do
  @derive [Poison.Encoder]
  defstruct [
    :team_uuid,
    :name,
    :schedule_uuid,
  ]
end
