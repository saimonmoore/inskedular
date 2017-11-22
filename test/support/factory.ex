defmodule Inskedular.Factory do
  use ExMachina

  def schedule_factory do
    %{
      name: "Hack Week Tournament",
      number_of_games: 4,
      game_duration: 60,
      startDate: ~N[2017-11-20 14:00:00.000000],
      endDate: ~N[2017-12-01 14:00:00.000000],
    }
  end
end
