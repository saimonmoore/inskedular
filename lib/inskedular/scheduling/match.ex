defmodule Inskedular.Scheduling.Match do
  use Ecto.Schema
  import Ecto.Changeset
  alias Inskedular.Scheduling.Match


  schema "scheduling_matches" do
    field :away_team_uuid, :string
    field :end_date, :utc_datetime
    field :local_team_uuid, :string
    field :match_number, :integer
    field :match_uuid, :string
    field :result, :string
    field :schedule_uuid, :string
    field :score_away_team, :integer
    field :score_local_team, :integer
    field :start_date, :utc_datetime
    field :status, :string

    timestamps()
  end

  @doc false
  def changeset(%Match{} = match, attrs) do
    match
    |> cast(attrs, [:match_uuid, :schedule_uuid, :local_team_uuid, :away_team_uuid, :start_date, :end_date, :status, :score_local_team, :score_away_team, :result, :match_number])
    |> validate_required([:match_uuid, :schedule_uuid, :local_team_uuid, :away_team_uuid, :start_date, :end_date, :status, :score_local_team, :score_away_team, :result, :match_number])
  end
end
