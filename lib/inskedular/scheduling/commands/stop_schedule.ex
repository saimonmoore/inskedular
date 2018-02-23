defmodule Inskedular.Scheduling.Commands.StopSchedule do
  defstruct [
    :schedule_uuid,
    :status,
  ]

  use ExConstructor
  use Vex.Struct

  validates :schedule_uuid, uuid: true
end
