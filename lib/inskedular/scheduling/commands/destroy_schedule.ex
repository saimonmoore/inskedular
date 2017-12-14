defmodule Inskedular.Scheduling.Commands.DestroySchedule do
  defstruct [
    :schedule_uuid,
  ]

  use ExConstructor
  use Vex.Struct

  validates :schedule_uuid, uuid: true
end
