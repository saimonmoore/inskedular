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
  ]

  alias Inskedular.Scheduling.Aggregates.Schedule
  alias Inskedular.Scheduling.Commands.{CreateSchedule,StartSchedule,IncludeMatchesInSchedule}
  alias Inskedular.Scheduling.Events.{ScheduleCreated,ScheduleStarted,MatchesCreated}

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
      game_duration: create.game_duration
    }
  end

  @doc """
  Trigger start of schedule (Will create all the first round matches)
  """
  def execute(%Schedule{}, %StartSchedule{} = start) do
    %ScheduleStarted{
      schedule_uuid: start.schedule_uuid,
      competition_type: start.competition_type,
    }
  end

  @doc """
  Mark a schedule as running
  """
  def execute(%Schedule{}, %IncludeMatchesInSchedule{} = included_matches) do
    %MatchesCreated{
      schedule_uuid: included_matches.schedule_uuid,
    }
  end

  # state mutators

  def apply(%Schedule{} = schedule, %ScheduleCreated{} = created) do
    %Schedule{schedule |
      uuid: created.schedule_uuid,
      name: created.name,
      start_date: created.start_date,
      end_date: created.end_date,
      number_of_games: created.number_of_games,
      number_of_weeks: created.number_of_weeks,
      game_duration: created.game_duration
    }
  end

  def apply(%Schedule{} = schedule, %MatchesCreated{} = created) do
    %Schedule{schedule |
      uuid: created.schedule_uuid,
      status: "running",
    }
  end

  # TODO: Add `competition_type`
  def apply(%Schedule{} = schedule, %ScheduleStarted{} = started) do
    %Schedule{schedule |
      uuid: started.schedule_uuid,
      status: "started",
    }
  end
end
