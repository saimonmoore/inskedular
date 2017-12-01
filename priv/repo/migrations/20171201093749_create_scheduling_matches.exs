defmodule Inskedular.Repo.Migrations.CreateSchedulingMatches do
  use Ecto.Migration

  def change do
    create table(:scheduling_matches, primary_key: false) do
      add :uuid, :string, primary_key: true
      add :schedule_uuid, :string
      add :match_number, :integer
      add :local_team_uuid, :string
      add :away_team_uuid, :string
      add :start_date, :timestamptz 
      add :end_date, :timestamptz 
      add :status, :string, default: "unplayed"
      add :score_local_team, :integer
      add :score_away_team, :integer
      add :result, :string

      timestamps(type: :timestamptz)
    end
  end
end
