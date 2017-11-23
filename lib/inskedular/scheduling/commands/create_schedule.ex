defmodule Inskedular.Scheduling.Commands.CreateSchedule do
  defstruct [
    :schedule_uuid,
    :name,
    :start_date,
    :end_date,
    :number_of_games,
    :game_duration,
  ]

  use ExConstructor
end
