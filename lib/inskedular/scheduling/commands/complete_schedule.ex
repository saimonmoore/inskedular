defmodule Inskedular.Scheduling.Commands.CompleteSchedule do
  defstruct [
    :schedule_uuid,
  ]

  use ExConstructor
  use Vex.Struct

  validates :schedule_uuid, uuid: true
end
