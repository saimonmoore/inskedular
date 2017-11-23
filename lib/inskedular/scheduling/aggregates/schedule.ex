defmodule Inskedular.Scheduling.Aggregates.Schedule do
  defstruct [
    :uuid,
    :name,
    :start_date,
    :end_date,
    :number_of_games,
    :game_duration,
  ]

  alias Inskedular.Scheduling.Aggregates.Schedule
  alias Inskedular.Scheduling.Commands.CreateSchedule
  alias Inskedular.Scheduling.Events.ScheduleCreated

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
      game_duration: create.game_duration
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
      game_duration: created.game_duration
    }
  end
end
