defmodule Inskedular.Scheduling do
  @moduledoc """
  The boundary for the Scheduling system.
  """

  alias Inskedular.Scheduling.Commands.CreateSchedule
  alias Inskedular.Scheduling.Projections.Schedule
  alias Inskedular.Scheduling.Queries.ScheduleByName
  alias Inskedular.{Repo,Router}

  @doc """
  Create a Schedule
  """
  def create_schedule(attrs \\ %{}) do
    uuid = UUID.uuid4()

    create_schedule = 
      attrs
      |> cast_attributes
      |> assign(:schedule_uuid, uuid)
      |> CreateSchedule.new()

    with :ok <- Router.dispatch(create_schedule, consistency: :strong) do
      get(Schedule, uuid)
    else
      reply -> reply
    end
  end


  @doc """
  Get an existing schedule by the name, or return `nil` if not present
  """
  def schedule_by_name(name) when is_binary(name) do
    name
    |> ScheduleByName.new()
    |> Repo.one()
  end

  defp get(schema, uuid) do
    case Repo.get(schema, uuid) do
      nil -> {:error, :not_found}
      projection -> {:ok, projection}
    end
  end

  defp assign(attrs, key, value), do: Map.put(attrs, key, value)

  defp cast_attributes(%{"game_duration" => game_duration, "number_of_games" => number_of_games} = attrs) do
    %{attrs | "number_of_games" => String.to_integer(number_of_games), "game_duration" => String.to_integer(game_duration)}
  end
end
