defmodule Inskedular.Scheduling.Commands.UpdateMatch do
  defstruct [
    :schedule_uuid,
    :match_uuid,
    :status,
    :score_local_team,
    :score_away_team,
    :result,
  ]

  use ExConstructor
  use Vex.Struct

  validates :match_uuid, uuid: true
  validates :schedule_uuid, uuid: true
  validates :status, presence: [message: "can't be empty"], string: true
  validates :result, presence: [message: "can't be empty"], string: true
end
