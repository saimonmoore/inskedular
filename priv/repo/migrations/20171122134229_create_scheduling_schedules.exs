defmodule Inskedular.Repo.Migrations.CreateSchedulingSchedules do
  use Ecto.Migration

  def change do
    create table(:scheduling_schedules) do
      add :name, :string
      add :start_date, :naive_datetime
      add :end_date, :naive_datetime
      add :number_of_games, :integer
      add :game_duration, :integer

      timestamps()
    end

  end
end
