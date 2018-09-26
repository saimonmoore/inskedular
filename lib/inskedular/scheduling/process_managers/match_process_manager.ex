defmodule Inskedular.Scheduling.ProcessManagers.MatchProcessManager do
  @moduledoc """
  Handle updating schedule when all matches are played
  """

  use Commanded.ProcessManagers.ProcessManager,
    name: "MatchProcessManager",
    router: Inskedular.Router,
    consistency: :strong

  defstruct [
    schedule_uuid: nil,
  ]

  alias Inskedular.Scheduling
  alias Inskedular.Scheduling.Events.{MatchUpdated}
  alias Inskedular.Scheduling.ProcessManagers.MatchProcessManager

  def interested?(%MatchUpdated{schedule_uuid: schedule_uuid}), do: {:start, schedule_uuid}
  def interested?(_event), do: false

  def handle(%MatchProcessManager{}, %MatchUpdated{schedule_uuid: schedule_uuid, result: result}) do
    IO.puts "[MatchProcessManager#handle MatchUpdated] =======> schedule_uuid: #{schedule_uuid} result: #{result}"

    case Scheduling.all_matches_played?(schedule_uuid) do
      true -> Scheduling.complete_schedule(%{schedule_uuid: schedule_uuid})
      _ -> nil 
    end
  end

  def apply(%MatchProcessManager{} = process_manager, %MatchUpdated{schedule_uuid: schedule_uuid}) do
    IO.puts "[MatchProcessManager#apply MatchUpdated] =======> Applying schedule_uuid: #{schedule_uuid}"
    %MatchProcessManager{process_manager |
      schedule_uuid: schedule_uuid,
    }
  end
end
