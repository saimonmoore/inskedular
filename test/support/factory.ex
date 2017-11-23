defmodule Inskedular.Factory do
  use ExMachina

  alias Inskedular.Scheduling.Commands.CreateSchedule

  def schedule_factory do
    %{
      name: "Hack Week Tournament",
      number_of_games: 4,
      game_duration: 60,
      start_date: ~N[2017-11-20 14:00:00.000000],
      end_date: ~N[2017-12-01 14:00:00.000000],
    }
  end

  def create_schedule_factory do
    struct(CreateSchedule, build(:schedule))
  end
end
