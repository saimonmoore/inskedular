defmodule Inskedular.Scheduling.Projections.Match do
  use Ecto.Schema

  @primary_key {:uuid, :binary_id, autogenerate: false}

  schema "scheduling_matches" do
    field :match_uuid, :string
    field :schedule_uuid, :string
    field :status, :string
    field :result, :string
    field :match_number, :integer
    field :local_team_uuid, :string
    field :away_team_uuid, :string
    field :score_away_team, :integer
    field :score_local_team, :integer
    field :start_date, :utc_datetime
    field :end_date, :utc_datetime

    timestamps(type: :utc_datetime)
  end
end
