defmodule Inskedular.Scheduling.Queries.TeamsByScheduleUuid do
  import Ecto.Query

  alias Inskedular.Scheduling.Projections.Team

  def new(schedule_uuid) do
    from t in Team,
    where: t.schedule_uuid == ^schedule_uuid and fragment("? is distinct from 'deleted'", field(t, :status))
  end
end
