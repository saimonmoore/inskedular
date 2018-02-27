defmodule Inskedular.Scheduling.Queries.ScheduleByName do
  import Ecto.Query

  alias Inskedular.Scheduling.Projections.Schedule

  def new(name) do
    from s in Schedule,
      where: s.name == ^name and fragment("? is distinct from 'deleted'", field(s, :status))
  end
end
