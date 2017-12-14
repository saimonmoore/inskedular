defmodule Inskedular.Scheduling.Projectors.Schedule do
  use Commanded.Projections.Ecto, name: "Scheduling.Projectors.Schedule",
                                  consistency: :strong
  use Inskedular.Support.Casting

  alias Inskedular.Scheduling.Events.{ScheduleCreated,ScheduleDestroyed,ScheduleStarted,MatchesCreated}
  alias Inskedular.Scheduling.Projections.Schedule

  project %ScheduleCreated{} = created do
    {:ok, start_date} = cast_datetime(created.start_date)
    {:ok, end_date} = cast_datetime(created.end_date)

    Ecto.Multi.insert(multi, :schedule, %Schedule{
      uuid: created.schedule_uuid,
      name: created.name,
      competition_type: created.competition_type,
      start_date: start_date,
      end_date: end_date,
      number_of_games: created.number_of_games,
      number_of_weeks: created.number_of_weeks,
      game_duration: created.game_duration
    })
  end

  project %ScheduleStarted{} = started do
    Ecto.Multi.update_all(multi, :schedule, schedule_query(started.schedule_uuid), set: [
      status: started.status,
    ])
  end

  project %ScheduleDestroyed{} = destroyed do
    IO.puts "[Projector.Schedule#project destroyed] =======> destroyed: #{inspect(destroyed)} "
    Ecto.Multi.delete_all(multi, :schedule, schedule_query(destroyed.schedule_uuid))
  end

  project %MatchesCreated{} = created do
    Ecto.Multi.update_all(multi, :schedule, schedule_query(created.schedule_uuid), set: [
      status: created.status,
    ])
  end

  defp schedule_query(schedule_uuid) do
    from(a in Schedule, where: a.uuid == ^schedule_uuid)
  end
end
