defmodule Inskedular.Scheduling.Projectors.Schedule do
  use Commanded.Projections.Ecto, name: "Scheduling.Projectors.Schedule",
                                  consistency: :strong
  use Inskedular.Support.Casting

  alias Inskedular.Scheduling.Events.{ScheduleCreated,ScheduleUpdated,ScheduleStarted,ScheduleRestarted,ScheduleStopped,MatchesCreated,ScheduleTerminated,ScheduleCompleted}
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

  project %ScheduleUpdated{} = updated do
    {:ok, start_date} = cast_datetime(updated.start_date)
    {:ok, end_date} = cast_datetime(updated.end_date)

    Ecto.Multi.update_all(multi, :schedule, schedule_query(updated.schedule_uuid), set: [
      name: updated.name,
      competition_type: updated.competition_type,
      start_date: start_date,
      end_date: end_date,
      number_of_games: updated.number_of_games,
      number_of_weeks: updated.number_of_weeks,
      game_duration: updated.game_duration
    ])
  end

  project %ScheduleStarted{} = started do
    Ecto.Multi.update_all(multi, :schedule, schedule_query(started.schedule_uuid), set: [
      status: started.status,
    ])
  end

  project %ScheduleRestarted{} = restarted do
    Ecto.Multi.update_all(multi, :schedule, schedule_query(restarted.schedule_uuid), set: [
      status: restarted.status,
    ])
  end

  project %ScheduleStopped{} = stopped do
    Ecto.Multi.update_all(multi, :schedule, schedule_query(stopped.schedule_uuid), set: [
      status: stopped.status,
    ])
  end

  project %ScheduleTerminated{} = terminated do
    Ecto.Multi.update_all(multi, :schedule, schedule_query(terminated.schedule_uuid), set: [
      status: terminated.status,
    ])
  end

  project %ScheduleCompleted{} = completed do
    Ecto.Multi.update_all(multi, :schedule, schedule_query(completed.schedule_uuid), set: [
      status: completed.status,
    ])
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
