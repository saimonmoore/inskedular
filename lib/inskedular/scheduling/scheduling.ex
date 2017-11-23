defmodule Inskedular.Scheduling do
  @moduledoc """
  The boundary for the Scheduling system.
  """

  alias Inskedular.Scheduling.Commands.CreateSchedule
  alias Inskedular.Scheduling.Projections.Schedule
  alias Inskedular.Repo
  alias Inskedular.Router

  @doc """
  Create a Schedule
  """
  def create_schedule(attrs \\ %{}) do
    uuid = UUID.uuid4()

    create_schedule = 
      attrs
      |> assign(:schedule_uuid, uuid)
      |> CreateSchedule.new()

    with :ok <- Router.dispatch(create_schedule, consistency: :strong) do
      get(Schedule, uuid)
    else
      reply -> reply
    end
  end

  defp get(schema, uuid) do
    case Repo.get(schema, uuid) do
      nil -> {:error, :not_found}
      projection -> {:ok, projection}
    end
  end

  defp assign(attrs, key, value), do: Map.put(attrs, key, value)
end
