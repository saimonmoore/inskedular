defmodule Inskedular.Scheduling.ProcessManagers.ScheduleProcessManager do
  @moduledoc """
  Handle creating matches for a started schedule
  """

  use Commanded.ProcessManagers.ProcessManager,
    name: "ScheduleProcessManager",
    router: Inskedular.Router,
    consistency: :strong

  defstruct [
    schedule_uuid: nil,
    competition_type: nil,
    round_number: 0,
    matches: [],
  ]

  alias Inskedular.Scheduling
  alias Inskedular.Scheduling.Events.{ScheduleStarted,MatchCreated,MatchesCreated}
  alias Inskedular.Scheduling.ProcessManagers.ScheduleProcessManager

  def interested?(%ScheduleStarted{schedule_uuid: schedule_uuid}), do: {:start, schedule_uuid}
  def interested?(%MatchCreated{schedule_uuid: schedule_uuid}), do: {:continue, schedule_uuid}
  def interested?(%MatchesCreated{schedule_uuid: schedule_uuid}), do: {:stop, schedule_uuid}
  def interested?(_event), do: false

  def handle(%ScheduleProcessManager{schedule_uuid: schedule_uuid}, %ScheduleStarted{schedule_uuid: schedule_uuid, competition_type: competition_type}) do
    Scheduling.create_matches(%{schedule_uuid: schedule_uuid, competition_type: competition_type, round_number: 0})
  end

  def apply(%ScheduleProcessManager{} = process_manager, %ScheduleStarted{schedule_uuid: schedule_uuid}) do
    %ScheduleProcessManager{process_manager |
      schedule_uuid: schedule_uuid
    }
  end

  def apply(%ScheduleProcessManager{matches: matches} = process_manager, %MatchCreated{} = match) do
    %ScheduleProcessManager{process_manager |
      matches: matches ++ [match]
    }
  end
end
