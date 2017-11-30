defmodule Inskedular.Scheduling.Projectors.Team do
  use Commanded.Projections.Ecto, name: "Scheduling.Projectors.Team",
                                  consistency: :strong
  alias Inskedular.Scheduling.Events.TeamCreated
  alias Inskedular.Scheduling.Projections.Team

  project %TeamCreated{} = created do
    Ecto.Multi.insert(multi, :team, %Team{
      uuid: created.team_uuid,
      name: created.name,
      schedule_uuid: created.schedule_uuid,
    })
  end
end
