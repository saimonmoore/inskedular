defmodule Inskedular.Scheduling.Aggregates.Team do
  defstruct [
    :uuid,
    :name,
    :schedule_uuid,
  ]

  alias Inskedular.Scheduling.Aggregates.Team
  alias Inskedular.Scheduling.Commands.CreateTeam
  alias Inskedular.Scheduling.Events.TeamCreated

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

  # state mutators

  def apply(%Team{} = team, %TeamCreated{} = created) do
    %Team{team |
      uuid: created.team_uuid,
      name: created.name,
      schedule_uuid: created.schedule_uuid,
    }
  end
end
