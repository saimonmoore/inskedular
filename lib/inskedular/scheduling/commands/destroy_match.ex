defmodule Inskedular.Scheduling.Commands.DestroyMatch do
  defstruct [
    :match_uuid,
  ]

  use ExConstructor
  use Vex.Struct

  validates :match_uuid, uuid: true
end
