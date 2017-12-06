defmodule Inskedular.Repo.Migrations.CreateSchedulingSchedules do
  use Ecto.Migration

  def change do
    create table(:scheduling_schedules, primary_key: false) do
      add :uuid, :uuid, primary_key: true
      add :name, :string
      add :status, :string, default: "inactive"
      add :competition_type, :string
      add :start_date, :timestamptz
      add :end_date, :timestamptz
      add :number_of_games, :integer
      add :number_of_weeks, :integer
      add :game_duration, :integer

      timestamps(type: :timestamptz)
    end

    create unique_index(:scheduling_schedules, [:name])
  end
end
