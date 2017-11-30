defmodule Inskedular.Scheduling.Commands.CreateTeam do
  defstruct [
    :team_uuid,
    :name,
    :schedule_uuid,
  ]

  use ExConstructor
  use Vex.Struct

  validates :team_uuid, uuid: true
  validates :name, presence: [message: "can't be empty"], string: true
  validates :schedule_uuid, presence: [message: "can't be empty"], string: true
end
