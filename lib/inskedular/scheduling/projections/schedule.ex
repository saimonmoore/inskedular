defmodule Inskedular.Scheduling.Projections.Schedule do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:uuid, :binary_id, autogenerate: false}

  schema "scheduling_schedules" do
    field :name, :string
    field :status, :string
    field :competition_type, :string
    field :number_of_games, :integer
    field :number_of_weeks, :integer
    field :game_duration, :integer
    field :start_date, :utc_datetime
    field :end_date, :utc_datetime

    timestamps(type: :utc_datetime)
  end

  def changeset(schedule, _params \\ %{}) do
    schedule
    |> unique_constraint(:name)
  end
end
