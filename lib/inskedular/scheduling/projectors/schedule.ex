defmodule Inskedular.Scheduling.Projectors.Schedule do
  use Commanded.Projections.Ecto, name: "Scheduling.Projectors.Schedule",
                                  consistency: :strong
  use Inskedular.Support.Casting

  alias Inskedular.Scheduling.Events.ScheduleCreated
  alias Inskedular.Scheduling.Projections.Schedule

  project %ScheduleCreated{} = created do
    {:ok, start_date} = cast_datetime(created.start_date)
    {:ok, end_date} = cast_datetime(created.end_date)

    Ecto.Multi.insert(multi, :schedule, %Schedule{
      uuid: created.schedule_uuid,
      name: created.name,
      start_date: start_date,
      end_date: end_date,
      number_of_games: created.number_of_games,
      game_duration: created.game_duration
    })
  end
end
