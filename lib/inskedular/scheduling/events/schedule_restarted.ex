defmodule Inskedular.Scheduling.Events.ScheduleRestarted do
  @derive [Poison.Encoder]
  defstruct [
    :schedule_uuid,
    :status,
  ]
end
