defmodule Inskedular.Scheduling.Commands.IncludeMatchInSchedule do
  defstruct [
    :schedule_uuid,
    :match_uuid,
    :match_number,
    :local_team_uuid,
    :away_team_uuid,
    :start_date,
    :end_date,
  ]

  use ExConstructor
  use Vex.Struct

  validates :schedule_uuid, uuid: true
  validates :match_uuid, uuid: true
  validates :local_team_uuid, uuid: true
  validates :away_team_uuid, uuid: true
  validates :match_number, presence: [message: "can't be empty"], number: true
  validates :start_date, presence: true
  validates :end_date, presence: true
end
