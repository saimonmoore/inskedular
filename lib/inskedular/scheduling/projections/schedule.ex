defmodule Inskedular.Scheduling.Projections.Schedule do
  use Ecto.Schema

  @primary_key {:uuid, :binary_id, autogenerate: false}

  schema "scheduling_schedules" do
    field :name, :string
    field :number_of_games, :integer
    field :game_duration, :integer
    field :start_date, :utc_datetime
    field :end_date, :utc_datetime

    timestamps(type: :utc_datetime)
  end
end
