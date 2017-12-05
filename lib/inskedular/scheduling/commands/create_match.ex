defmodule Inskedular.Scheduling.Commands.CreateMatch do
  defstruct [
    :match_uuid,
    :schedule_uuid,
    :match_number,
    :local_team_uuid,
    :away_team_uuid,
    :start_date,
    :end_date,
  ]

  use ExConstructor
  use Vex.Struct

  validates :schedule_uuid, uuid: true
  validates :match_number, number: true
  validates :local_team_uuid, uuid: true
  validates :away_team_uuid, uuid: true
end
