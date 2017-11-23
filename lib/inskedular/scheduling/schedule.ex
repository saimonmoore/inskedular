defmodule Inskedular.Scheduling.Schedule do
  use Ecto.Schema
  import Ecto.Changeset
  alias Inskedular.Scheduling.Schedule


  schema "scheduling_schedules" do
    field :game_duration, :integer
    field :name, :string
    field :number_of_games, :integer
    field :start_date, :naive_datetime
    field :end_date, :naive_datetime

    timestamps()
  end

  @doc false
  def changeset(%Schedule{} = schedule, attrs) do
    schedule
    |> cast(attrs, [:name, :start_date, :end_date, :number_of_games, :game_duration])
    |> validate_required([:name, :start_date, :end_date, :number_of_games, :game_duration])
  end
end
