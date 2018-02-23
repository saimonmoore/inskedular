defmodule Inskedular.Scheduling.Events.ScheduleStopped do
  @derive [Poison.Encoder]
  defstruct [
    :schedule_uuid,
    :status,
  ]
end
