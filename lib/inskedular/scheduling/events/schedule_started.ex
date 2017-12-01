defmodule Inskedular.Scheduling.Events.ScheduleStarted do
  @derive [Poison.Encoder]
  defstruct [
    :schedule_uuid,
    :competition_type
  ]
end
