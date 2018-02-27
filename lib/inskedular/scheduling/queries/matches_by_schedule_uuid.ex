defmodule Inskedular.Scheduling.Queries.MatchesByScheduleUuid do
  import Ecto.Query

  alias Inskedular.Scheduling.Projections.Match

  def new(schedule_uuid) do
    from m in Match,
      where: m.schedule_uuid == ^schedule_uuid and fragment("? is distinct from 'deleted'", field(m, :status))
  end
end
