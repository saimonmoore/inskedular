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

  alias Inskedular.Scheduling.Validators.UniqueName
  alias Inskedular.Support.Middleware.Uniqueness.UniqueFields
  alias Inskedular.Scheduling.Commands.CreateSchedule

  validates :schedule_uuid, uuid: true
  validates :name, presence: [message: "can't be empty"], string: true, by: &UniqueName.validate/2
  validates :number_of_games, presence: true, number: true
  validates :game_duration, presence: true, number: true

  defimpl UniqueFields, for: CreateSchedule do
    def unique(%Inskedular.Scheduling.Commands.CreateSchedule{schedule_uuid: schedule_uuid}), do: [
      {:name, "has already been taken", schedule_uuid},
    ]
  end  
end
