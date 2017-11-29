defmodule Inskedular.Repo.Migrations.CreateSchedulingTeams do
  use Ecto.Migration

  def change do
    create table(:scheduling_teams, primary_key: false) do
      add :uuid, :uuid, primary_key: true
      add :name, :string

      timestamps(type: :timestamptz)
    end

    create unique_index(:scheduling_teams, [:name])
  end
end
