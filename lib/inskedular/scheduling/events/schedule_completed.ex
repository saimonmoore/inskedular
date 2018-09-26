defmodule Inskedular.Scheduling.Events.ScheduleCompleted do
  @derive [Poison.Encoder]
  defstruct [
    :schedule_uuid,
    :status,
  ]
end
