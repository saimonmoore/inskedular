defmodule Inskedular.Repo.Migrations.CreateSchedulingMatches do
  use Ecto.Migration

  def change do
    create table(:scheduling_matches, primary_key: false) do
      add :uuid, :uuid, primary_key: true
      add :schedule_uuid, references(:scheduling_schedules, column: :uuid, on_delete: :delete_all, type: :uuid)
      add :match_number, :integer
      add :local_team_uuid, :uuid
      add :away_team_uuid, :uuid
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
