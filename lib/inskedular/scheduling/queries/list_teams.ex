defmodule Inskedular.Scheduling.Queries.ListTeams do
  import Ecto.Query

  alias Inskedular.Scheduling.Projections.Team

  defmodule Options do
    defstruct [
      schedule_uuid: nil,
    ]

    use ExConstructor
  end

  def execute(params, repo) do
    options = Options.new(params)
    query = query(options)

    teams = query |> repo.all()

    teams
  end

  defp query(options) do
    from(t in Team, where: fragment("? is distinct from 'deleted'", field(t, :status)))
    |> filter_by_schedule(options)
    |> order_by([a], asc: a.inserted_at)
  end

  defp filter_by_schedule(query, %Options{schedule_uuid: nil}), do: query
  defp filter_by_schedule(query, %Options{schedule_uuid: schedule_uuid}) do
    query |> where(schedule_uuid: ^schedule_uuid)
  end
end
