defmodule Inskedular.Scheduling.Projectors.Team do
  use Commanded.Projections.Ecto, name: "Scheduling.Projectors.Team",
                                  consistency: :strong
  alias Inskedular.Scheduling.Events.{TeamCreated,TeamUpdated,TeamDestroyed}
  alias Inskedular.Scheduling.Projections.Team

  project %TeamCreated{} = created do
    Ecto.Multi.insert(multi, :team, %Team{
      uuid: created.team_uuid,
      name: created.name,
      schedule_uuid: created.schedule_uuid,
    })
  end

  project %TeamUpdated{} = updated do
    IO.puts "[Projector.Team#project updated] =======> updated: #{inspect(updated)} "
    Ecto.Multi.update_all(multi, :team, team_query(updated.team_uuid), set: [
      name: updated.name,
    ])
  end

  project %TeamDestroyed{} = destroyed do
    IO.puts "[Projector.Team#project destroyed] =======> destroyed: #{inspect(destroyed)} "
    Ecto.Multi.delete_all(multi, :team, team_query(destroyed.team_uuid))
  end

  defp team_query(team_uuid) do
    from(a in Team, where: a.uuid == ^team_uuid)
  end
end
