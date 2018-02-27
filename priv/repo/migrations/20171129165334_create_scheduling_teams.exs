defmodule Inskedular.Repo.Migrations.CreateSchedulingTeams do
  use Ecto.Migration

  def change do
    create table(:scheduling_teams, primary_key: false) do
      add :uuid, :uuid, primary_key: true
      add :name, :string
      add :schedule_uuid, references(:scheduling_schedules, column: :uuid, on_delete: :delete_all, type: :uuid)

      timestamps(type: :timestamptz)
    end
  end
end
