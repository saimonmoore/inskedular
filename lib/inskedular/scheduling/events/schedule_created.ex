defmodule Inskedular.Scheduling.Events.ScheduleCreated do
  @derive [Poison.Encoder]
  defstruct [
    :schedule_uuid,
    :name,
    :start_date,
    :end_date,
    :number_of_games,
    :game_duration,
  ]
end
