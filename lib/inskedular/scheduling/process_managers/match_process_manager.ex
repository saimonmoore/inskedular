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
    matches_played: 0,
  ]

  alias Inskedular.Scheduling
  alias Inskedular.Scheduling.Events.{MatchUpdated}
  alias Inskedular.Scheduling.ProcessManagers.MatchProcessManager

  def interested?(%MatchUpdated{schedule_uuid: schedule_uuid, status: "played"}), do: {:start, schedule_uuid}
  def interested?(_event), do: false

  def handle(%MatchProcessManager{matches_played: matches_played}, %MatchUpdated{schedule_uuid: schedule_uuid, status: "played"}) do
    IO.puts "[MatchProcessManager#handle MatchUpdated] =======> schedule_uuid: #{schedule_uuid} status: played"

    case Scheduling.matches_count(schedule_uuid) == (matches_played + 1) do
      true -> Scheduling.complete_schedule(%{schedule_uuid: schedule_uuid})
        _ -> []
    end
  end

  def apply(%MatchProcessManager{} = process_manager, %MatchUpdated{schedule_uuid: schedule_uuid, status: "played"}) do
    IO.puts "[MatchProcessManager#apply MatchUpdated] =======> Applying schedule_uuid: #{schedule_uuid} status: played"

    %MatchProcessManager{increment_matches_played(process_manager) |
      schedule_uuid: schedule_uuid,
    }
  end

  # private helpers

  defp increment_matches_played(%MatchProcessManager{schedule_uuid: schedule_uuid, matches_played: matches_played} = process_manager) do
    IO.puts "[MatchProcessManager#increment_matches_played] =======> for schedule_uuid: #{schedule_uuid} matches_played: #{matches_played}"

    %MatchProcessManager{process_manager | matches_played: matches_played + 1}
  end
end
