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
    round_number: 0,
    matches: [],
  ]

  alias Inskedular.Scheduling
  alias Inskedular.Scheduling.Events.{ScheduleStarted,ScheduleRestarted,ScheduleDestroyed}
  alias Inskedular.Scheduling.ProcessManagers.ScheduleProcessManager

  def interested?(%ScheduleStarted{schedule_uuid: schedule_uuid}), do: {:start, schedule_uuid}
  def interested?(%ScheduleRestarted{schedule_uuid: schedule_uuid}), do: {:start, schedule_uuid}
  def interested?(%ScheduleDestroyed{schedule_uuid: schedule_uuid}), do: {:start, schedule_uuid}
  def interested?(_event), do: false

  def handle(%ScheduleProcessManager{}, %ScheduleStarted{schedule_uuid: schedule_uuid}) do
    IO.puts "[ScheduleProcessManager#handle ScheduleStarted] =======> ...."
    commands = Scheduling.create_matches(%{schedule_uuid: schedule_uuid, round_number: 0})
    IO.puts "[#handle ScheduleStarted] =======> commands: #{inspect(commands)}"
    commands
  end

  def handle(%ScheduleProcessManager{}, %ScheduleRestarted{schedule_uuid: schedule_uuid}) do
    IO.puts "[ScheduleProcessManager#handle ScheduleRestarted] =======> schedule_uuid: #{schedule_uuid}"
    Scheduling.destroy_matches(%{schedule_uuid: schedule_uuid})
    IO.puts "[ScheduleProcessManager#handle ScheduleRestarted] =======> matches destroyed"
    commands = Scheduling.create_matches(%{schedule_uuid: schedule_uuid, round_number: 0})
    IO.puts "[#handle ScheduleRestarted] =======> commands: #{inspect(commands)}"
    commands
  end

  def handle(%ScheduleProcessManager{}, %ScheduleDestroyed{schedule_uuid: schedule_uuid}) do
    IO.puts "[ScheduleProcessManager#handle ScheduleDestroyed] =======> schedule_uuid: #{schedule_uuid}"
    Scheduling.terminate_schedule(%{schedule_uuid: schedule_uuid})
    IO.puts "[ScheduleProcessManager#handle ScheduleDestroyed] =======> updated schedule's status to terminated!"
    Scheduling.destroy_matches(%{schedule_uuid: schedule_uuid})
    IO.puts "[ScheduleProcessManager#handle ScheduleDestroyed] =======> destroyed matches"
    Scheduling.destroy_teams(%{schedule_uuid: schedule_uuid})
    IO.puts "[ScheduleProcessManager#handle ScheduleDestroyed] =======> destroyed teams"
    nil
  end

  def apply(%ScheduleProcessManager{} = process_manager, %ScheduleStarted{schedule_uuid: schedule_uuid}) do
    IO.puts "[ScheduleProcessManager#apply ScheduleStarted] =======> ...."
    %ScheduleProcessManager{process_manager |
      schedule_uuid: schedule_uuid,
    }
  end
end
