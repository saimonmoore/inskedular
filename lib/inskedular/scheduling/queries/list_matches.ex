defmodule Inskedular.Scheduling.Queries.ListMatches do
  import Ecto.Query

  alias Inskedular.Scheduling.Projections.Match

  defmodule Options do
    defstruct [
      schedule_uuid: nil,
    ]

    use ExConstructor
  end

  def execute(params, repo) do
    options = Options.new(params)
    query = query(options)

    matches = query |> repo.all()

    matches
  end

  defp query(options) do
    from(m in Match, where: fragment("? is distinct from 'deleted'", field(m, :status)))
    |> filter_by_schedule(options)
    |> order_by([a], asc: a.match_number)
  end

  defp filter_by_schedule(query, %Options{schedule_uuid: nil}), do: query
  defp filter_by_schedule(query, %Options{schedule_uuid: schedule_uuid}) do
    query |> where(schedule_uuid: ^schedule_uuid)
  end
end
