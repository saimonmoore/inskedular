defmodule Inskedular.Scheduling.Events.ScheduleTerminated do
  @derive [Poison.Encoder]
  defstruct [
    :schedule_uuid,
    :status,
  ]
end
