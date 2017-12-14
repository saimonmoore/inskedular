defmodule Inskedular.Scheduling.Commands.UpdateTeam do
  defstruct [
    :team_uuid,
    :name,
  ]

  use ExConstructor
  use Vex.Struct

  validates :team_uuid, uuid: true
  validates :name, presence: [message: "can't be empty"], string: true
end
