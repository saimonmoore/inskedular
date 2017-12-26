defmodule Inskedular.Scheduling.Commands.UpdateSchedule do
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

  use ExConstructor
  use Vex.Struct

  alias Inskedular.Scheduling.Validators.UniqueName
  alias Inskedular.Support.Middleware.Uniqueness.UniqueFields
  alias Inskedular.Scheduling.Commands.UpdateSchedule

  validates :schedule_uuid, uuid: true
  validates :name, presence: [message: "can't be empty"], string: true, by: &UniqueName.validate/2
  validates :number_of_games, presence: true, number: true
  validates :number_of_weeks, presence: true, number: true
  validates :game_duration, number: true
  validates :competition_type, presence: true #, in: ~w(knockout league)

  defimpl UniqueFields, for: UpdateSchedule do
    def unique(%Inskedular.Scheduling.Commands.UpdateSchedule{schedule_uuid: schedule_uuid}), do: [
      {:name, "has already been taken", schedule_uuid},
    ]
  end  
end
