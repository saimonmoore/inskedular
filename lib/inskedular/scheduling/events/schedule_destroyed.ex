defmodule Inskedular.Scheduling.Events.ScheduleDestroyed do
  @derive [Poison.Encoder]
  defstruct [
    :schedule_uuid,
    :status
  ]
end
