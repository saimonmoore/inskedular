defmodule Inskedular.Scheduling.Commands.DestroyTeam do
  defstruct [
    :team_uuid,
  ]

  use ExConstructor
  use Vex.Struct

  validates :team_uuid, uuid: true
end
