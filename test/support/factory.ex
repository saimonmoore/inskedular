defmodule Inskedular.Factory do
  use ExMachina

  alias Inskedular.Scheduling.Commands.CreateSchedule

  def schedule_factory do
    %{
      name: "Hack Week Tournament",
      number_of_games: 4,
      game_duration: 60,
      start_date: date_time_for("2017-11-20T14:00:00.000000+02:00"),
      end_date: date_time_for("2017-12-01T14:00:00.000000+02:00"),
    }
  end

  def schedule_params_factory do
    %{
      name: "Hack Week Tournament",
      number_of_games: "4",
      game_duration: "60",
      start_date: "2017-11-20T14:00:00.000000+02:00",
      end_date: "2017-12-01T14:00:00.000000+02:00",
    }
  end

  def build_schedule_params(attrs \\ []) do
    build(:schedule_params, attrs) 
    |> Map.new(fn {k, v} -> {Atom.to_string(k), v} end)
  end

  def create_schedule_factory do
    struct(CreateSchedule, build(:schedule))
  end

  defp date_time_for(string) do
    { :ok, date_time, _utc_offset } = DateTime.from_iso8601(string)
    date_time
  end
end
