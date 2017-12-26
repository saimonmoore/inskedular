defmodule Inskedular.Scheduling.Aggregates.Schedule do
  defstruct [
    :uuid,
    :name,
    :status,
    :start_date,
    :end_date,
    :number_of_games,
    :number_of_weeks,
    :game_duration,
    :competition_type,
  ]

  alias Inskedular.Scheduling.Aggregates.Schedule
  alias Inskedular.Scheduling.Commands.{CreateSchedule,UpdateSchedule,DestroySchedule,StartSchedule,IncludeMatchesInSchedule}
  alias Inskedular.Scheduling.Events.{ScheduleCreated,ScheduleUpdated,ScheduleDestroyed,ScheduleStarted,MatchesCreated}

  @doc """
  Create a new schedule
  """
  def execute(%Schedule{uuid: nil}, %CreateSchedule{} = create) do
    %ScheduleCreated{
      schedule_uuid: create.schedule_uuid,
      name: create.name,
      start_date: create.start_date,
      end_date: create.end_date,
      number_of_games: create.number_of_games,
      number_of_weeks: create.number_of_weeks,
      game_duration: create.game_duration,
      competition_type: create.competition_type,
    }
  end

  @doc """
  Update a new schedule
  """
  def execute(%Schedule{}, %UpdateSchedule{} = update) do
    %ScheduleUpdated{
      schedule_uuid: update.schedule_uuid,
      name: update.name,
      start_date: update.start_date,
      end_date: update.end_date,
      number_of_games: update.number_of_games,
      number_of_weeks: update.number_of_weeks,
      game_duration: update.game_duration,
      competition_type: update.competition_type,
    }
  end

  @doc """
  Trigger start of schedule (Will create all the first round matches)
  """
  def execute(%Schedule{}, %StartSchedule{} = start) do
    %ScheduleStarted{
      schedule_uuid: start.schedule_uuid,
      status: "started",
    }
  end

  def execute(%Schedule{status: :deleted}, %DestroySchedule{}) do
    {:error, :already_deleted}
  end

  def execute(%Schedule{}, %DestroySchedule{} = destroy) do
    %ScheduleDestroyed{
      schedule_uuid: destroy.schedule_uuid,
    }
  end

  @doc """
  Mark a schedule as running
  """
  def execute(%Schedule{}, %IncludeMatchesInSchedule{} = included_matches) do
    %MatchesCreated{
      schedule_uuid: included_matches.schedule_uuid,
      status: "running",
    }
  end

  # state mutators

  def apply(%Schedule{} = schedule, %ScheduleCreated{} = created) do
    %Schedule{schedule |
      uuid: created.schedule_uuid,
      name: created.name,
      competition_type: created.competition_type,
      start_date: created.start_date,
      end_date: created.end_date,
      number_of_games: created.number_of_games,
      number_of_weeks: created.number_of_weeks,
      game_duration: created.game_duration
    }
  end

  def apply(%Schedule{} = schedule, %ScheduleUpdated{} = updated) do
    %Schedule{schedule |
      name: updated.name,
      competition_type: updated.competition_type,
      start_date: updated.start_date,
      end_date: updated.end_date,
      number_of_games: updated.number_of_games,
      number_of_weeks: updated.number_of_weeks,
      game_duration: updated.game_duration
    }
  end

  def apply(%Schedule{} = schedule, %MatchesCreated{} = created) do
    %Schedule{schedule |
      uuid: created.schedule_uuid,
      status: created.status,
    }
  end

  def apply(%Schedule{} = schedule, %ScheduleStarted{} = started) do
    %Schedule{schedule |
      uuid: started.schedule_uuid,
      status: started.status,
    }
  end

  def apply(%Schedule{} = schedule, %ScheduleDestroyed{}) do
    %Schedule{schedule | status: :deleted }
  end
end
