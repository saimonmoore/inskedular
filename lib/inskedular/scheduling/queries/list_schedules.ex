defmodule Inskedular.Scheduling.Queries.ListSchedules do
  import Ecto.Query

  alias Inskedular.Scheduling.Projections.Schedule

  defmodule Options do
    defstruct [
      limit: 20,
      offset: 0,
    ]

    use ExConstructor
  end

  def execute(params, repo) do
    options = Options.new(params)
    query = query(options)

    schedules = query |> repo.all()

    schedules
  end

  defp query(_options) do
    from s in Schedule,
    where: fragment("? is distinct from 'terminated'", field(s, :status))
  end
end
