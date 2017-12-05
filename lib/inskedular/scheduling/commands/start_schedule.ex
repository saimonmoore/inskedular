defmodule Inskedular.Scheduling.Commands.StartSchedule do
  defstruct [
    :schedule_uuid,
    :competition_type,
  ]

  use ExConstructor
  use Vex.Struct

  validates :schedule_uuid, uuid: true
  # validates :competition_type, in: ~w(knockout league)
end
