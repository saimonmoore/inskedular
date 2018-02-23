defmodule Inskedular.Scheduling.Events.MatchDestroyed do
  @derive [Poison.Encoder]
  defstruct [
    :match_uuid,
    :status,
  ]
end
