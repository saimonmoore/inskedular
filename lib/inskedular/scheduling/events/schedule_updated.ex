defmodule Inskedular.Scheduling.Events.ScheduleUpdated do
  @derive [Poison.Encoder]
  defstruct [
    :schedule_uuid,
    :name,
    :competition_type,
    :start_date,
    :end_date,
    :number_of_games,
    :number_of_weeks,
    :game_duration,
  ]
end
