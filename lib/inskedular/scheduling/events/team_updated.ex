defmodule Inskedular.Scheduling.Events.TeamUpdated do
  @derive [Poison.Encoder]
  defstruct [
    :team_uuid,
    :name,
  ]
end
