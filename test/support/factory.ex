defmodule Inskedular.Factory do
  use ExMachina

  alias Inskedular.Scheduling.Commands.CreateSchedule

  def schedule_factory do
    %{
      name: "Hack Week Tournament",
      number_of_games: 4,
      game_duration: 60,
      start_date: date_time_for("2017-11-20T14:00:00.000+02:00"),
      end_date: date_time_for("2017-12-01T14:00:00.000+02:00"),
    }
  end

  def create_schedule_factory do
    struct(CreateSchedule, build(:schedule))
  end

  defp date_time_for(string) do
    { :ok, date_time, _utc_offset } = DateTime.from_iso8601(string)
    date_time
  end
end
