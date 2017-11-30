defmodule Inskedular.Scheduling do
  @moduledoc """
  The boundary for the Scheduling system.
  """

  use Inskedular.Support.Casting

  alias Inskedular.Scheduling.Commands.{CreateSchedule,CreateTeam}
  alias Inskedular.Scheduling.Projections.{Schedule,Team}
  alias Inskedular.Scheduling.Queries.{ScheduleByName,ListSchedules,TeamByName,ListTeams}
  alias Inskedular.{Repo,Router}

  #######
  # Schedule
  #

  @doc """
  Returns most recent schedules globally by default.
  """
  @spec list_schedules(params :: map()) :: {schedules :: list(Schedule.t), schedule_count :: non_neg_integer()}
  def list_schedules(params \\ %{})
  def list_schedules(params) do
    ListSchedules.execute(params, Repo)
  end

  @doc """
  Create a Schedule
  """
  def create_schedule(attrs \\ %{}) do
    uuid = UUID.uuid4()

    create_schedule = 
      attrs
      |> cast_schedule_attributes
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

  defp cast_schedule_attributes(%{
    "game_duration" => game_duration,
    "number_of_games" => number_of_games,
    "start_date" => start_date_string,
    "end_date" => end_date_string,
  } = attrs) do

    {:ok, start_date} = cast_datetime(start_date_string)
    {:ok, end_date} = cast_datetime(end_date_string)

    %{attrs |
      "number_of_games" => String.to_integer(number_of_games),
      "game_duration" => String.to_integer(game_duration),
      "start_date" => start_date,
      "end_date" => end_date,
    }
  end


  #############
  # TEAM

  @doc """
  Returns most recent teams globally by default.
  """
  @spec list_teams(params :: map()) :: {teams :: list(Team.t), schedule_count :: non_neg_integer()}
  def list_teams(params \\ %{})
  def list_teams(params) do
    params
    |> cast_list_team_params
    |> ListTeams.execute(Repo)
  end

  @doc """
  Create a Team
  """
  def create_team(attrs \\ %{}) do
    uuid = UUID.uuid4()

    create_team = 
      attrs
      |> assign(:team_uuid, uuid)
      |> CreateTeam.new()

    with :ok <- Router.dispatch(create_team, consistency: :strong) do
      get(Team, uuid)
    else
      reply -> reply
    end
  end

  @doc """
  Get an existing team by the name, or return `nil` if not present
  """
  def team_by_name(name) when is_binary(name) do
    name
    |> TeamByName.new()
    |> Repo.one()
  end

  defp cast_list_team_params(%{
    "schedule_uuid" => schedule_uuid,
  }) do

    %{ schedule_uuid: schedule_uuid }
  end

  ############
  # Common
  #

  defp get(schema, uuid) do
    case Repo.get(schema, uuid) do
      nil -> {:error, :not_found}
      projection -> {:ok, projection}
    end
  end

  defp assign(attrs, key, value), do: Map.put(attrs, key, value)
end
