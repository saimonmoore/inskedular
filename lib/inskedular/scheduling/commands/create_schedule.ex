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
  use Vex.Struct

  validates :schedule_uuid, uuid: true
  validates :name, presence: [message: "can't be empty"], string: true
  validates :number_of_games, presence: true, number: true
  validates :game_duration, presence: true, number: true
end
