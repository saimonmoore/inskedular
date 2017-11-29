defmodule Inskedular.Fixture do
  import Inskedular.Factory

  alias Inskedular.Scheduling

  def build_schedule_params(attrs \\ []) do
    build(:schedule_params, attrs) 
    |> Map.new(fn {k, v} -> {Atom.to_string(k), v} end)
  end

  def create_schedule(attrs \\ []) do
    build_schedule_params(attrs) |> Scheduling.create_schedule()
  end

  def create_schedules(_args) do
    {:ok, schedule1} = create_schedule()
    {:ok, schedule2} = create_schedule(game_duration: "50", number_of_games: "8", name: "Crypto Tournament")

    [
      schedules: [schedule1, schedule2]
    ]
  end
end
