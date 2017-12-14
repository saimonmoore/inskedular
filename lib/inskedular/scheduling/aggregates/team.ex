defmodule Inskedular.Scheduling.Aggregates.Team do
  defstruct [
    :uuid,
    :name,
    :schedule_uuid,
    :status,
  ]

  alias Inskedular.Scheduling.Aggregates.Team
  alias Inskedular.Scheduling.Commands.{CreateTeam,UpdateTeam,DestroyTeam}
  alias Inskedular.Scheduling.Events.{TeamCreated,TeamUpdated,TeamDestroyed}

  @doc """
  Create a new team
  """
  def execute(%Team{uuid: nil}, %CreateTeam{} = create) do
    %TeamCreated{
      team_uuid: create.team_uuid,
      name: create.name,
      schedule_uuid: create.schedule_uuid,
    }
  end

  def execute(%Team{}, %UpdateTeam{} = update) do
    %TeamUpdated{
      team_uuid: update.team_uuid,
      name: update.name,
    }
  end

  def execute(%Team{status: :deleted}, %DestroyTeam{}) do
    {:error, :already_deleted}
  end

  def execute(%Team{}, %DestroyTeam{} = destroy) do
    %TeamDestroyed{
      team_uuid: destroy.team_uuid,
    }
  end

  # state mutators

  def apply(%Team{} = team, %TeamCreated{} = created) do
    %Team{team |
      uuid: created.team_uuid,
      name: created.name,
      schedule_uuid: created.schedule_uuid,
    }
  end

  def apply(%Team{} = team, %TeamUpdated{} = updated) do
    %Team{team |
      uuid: updated.team_uuid,
      name: updated.name,
    }
  end

  def apply(%Team{} = team, %TeamDestroyed{}) do
    %Team{team | status: :deleted }
  end
end
