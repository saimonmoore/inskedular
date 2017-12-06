defmodule Inskedular.Scheduling.Events.MatchesCreated do
  @derive [Poison.Encoder]
  defstruct [
    :schedule_uuid,
    :status,
  ]
end
