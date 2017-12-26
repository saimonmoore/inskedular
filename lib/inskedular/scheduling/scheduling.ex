defmodule Inskedular.Scheduling do
  @moduledoc """
  The boundary for the Scheduling system.
  """

  use Inskedular.Support.Casting

  import Comb

  alias Inskedular.Scheduling.Commands.{CreateSchedule,UpdateSchedule,DestroySchedule,StartSchedule,CreateTeam,CreateMatch,IncludeMatchesInSchedule,UpdateMatch,UpdateTeam,DestroyTeam}
  alias Inskedular.Scheduling.Projections.{Schedule,Team,Match}
  alias Inskedular.Scheduling.Queries.{ScheduleByName,ListSchedules,TeamByName,ListTeams,ListMatches}
  alias Inskedular.{Repo,Router}

  #######
  # Schedule
  #

  @doc """
  Get a single schedule by their UUID
  """
  def schedule_by_uuid(uuid) when is_binary(uuid) do
    Repo.get(Schedule, uuid)
  end

  @doc """
  Returns most recent schedules globally by default.
  """
  @spec list_schedules(params :: map()) :: {schedules :: list(Schedule.t), schedule_count :: non_neg_integer()}
  def list_schedules(params \\ %{})
  def list_schedules(params) do
    ListSchedules.execute(params, Repo)
  end

  @doc """
  Update a Schedule's status
  """
  def update_schedule_status(%{schedule_uuid: schedule_uuid, status: status}) do
    case status do
      "start" -> start_schedule(schedule_uuid)
      "stop"  -> stop_schedule(schedule_uuid)
      _       -> nil
    end
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
  Update a Schedule
  """
  def update_schedule(%{"id" => uuid} = attrs \\ %{}) do
    update_schedule = 
      attrs
      |> cast_schedule_attributes
      |> assign(:schedule_uuid, uuid)
      |> Map.delete("id")
      |> UpdateSchedule.new

    with :ok <- Router.dispatch(update_schedule, consistency: :strong) do
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
    "number_of_weeks" => number_of_weeks,
    "start_date" => start_date_string,
    "end_date" => end_date_string,
  } = attrs) do
    {:ok, start_date} = cast_datetime(start_date_string)
    {:ok, end_date} = cast_datetime(end_date_string)

    %{attrs |
      "number_of_games" => cast_integer_attribute(number_of_games),
      "number_of_weeks" => cast_integer_attribute(number_of_weeks),
      "game_duration" => cast_integer_attribute(game_duration),
      "start_date" => start_date,
      "end_date" => end_date,
    }
  end

  def cast_integer_attribute(attr) when is_integer(attr), do: attr
  def cast_integer_attribute(attr) when is_binary(attr) do
    String.to_integer(attr)
  end

  defp stop_schedule(_schedule_uuid) do
  end

  defp start_schedule(schedule_uuid) do
    start_schedule = %{}
      |> assign(:schedule_uuid, schedule_uuid)
      |> StartSchedule.new()

    with :ok <- Router.dispatch(start_schedule) do
      get(Schedule, schedule_uuid)
    else
      reply -> reply
    end
  end

  def create_matches(%{schedule_uuid: schedule_uuid, round_number: round_number}) do
    {:ok, %Schedule{competition_type: competition_type} = schedule} = get(Schedule, schedule_uuid)
    commands = case String.to_atom(competition_type) do
      :league -> create_league_matches(%{schedule: schedule, round_number: round_number})
      :knockout -> create_knockout_matches(%{schedule: schedule, round_number: round_number})
      _ -> []
    end

    case Enum.any?(commands) do
      true -> commands ++ [matches_created(schedule_uuid)]
      false -> []
    end
  end

  # TODO: Calculate proper league combinations
  defp create_league_matches(%{schedule: schedule, round_number: round_number}) do
    teams = list_teams(%{"schedule_uuid" => schedule.uuid})

    calculate_league_matches(schedule, teams, round_number)
    |> Enum.map(
      fn(match) ->
        create_match(match)
      end
    )
  end

  # TODO: Calculate proper knockout combinations
  defp create_knockout_matches(%{schedule_uuid: schedule_uuid, round_number: round_number}) do
    schedule = get(Schedule, schedule_uuid)
    teams = list_teams(%{"schedule_uuid" => schedule_uuid})

    calculate_knockout_matches(schedule, teams, round_number)
    |> Enum.map(
      fn(match) -> create_match(match) end
    )
  end

  defp calculate_league_matches(schedule, teams, _round_number) do
    teams
    |> Enum.map(fn(team) -> 
      team.uuid
    end)
    |> combinations(2)
    |> Enum.with_index
    |> Enum.map(fn(combination) ->
      {pair, index} = combination
      %{schedule_uuid: schedule.uuid, local_team_uuid: List.first(pair), away_team_uuid: List.last(pair), match_number: index, start_date: nil, end_date: nil }
    end)
  end

  defp calculate_knockout_matches(schedule, teams, _round_number) do
    teams
    |> Enum.map(fn(team) -> team.team_uuid end)
    |> combinations(2)
    |> Enum.with_index
    |> Enum.map(fn(combination) ->
      {pair, index} = combination
      %{schedule_uuid: schedule.uuid, local_team_uuid: List.first(pair), away_team_uuid: List.last(pair), match_number: index, start_date: nil, end_date: nil }
    end)
  end

  defp create_match(%{schedule_uuid: schedule_uuid, local_team_uuid: local_team_uuid, away_team_uuid: away_team_uuid, match_number: match_number, start_date: start_date, end_date: end_date }) do
    match_uuid = UUID.uuid4()

    create_match = %{
      match_number: match_number,
      local_team_uuid: local_team_uuid,
      away_team_uuid: away_team_uuid,
      start_date: start_date,
      end_date: end_date,
    }
    |> assign(:schedule_uuid, schedule_uuid)
    |> assign(:match_uuid, match_uuid)
    |> CreateMatch.new()

    create_match
  end

  @doc """
  Destroy a Schedule
  """
  def destroy_schedule(uuid) do
    destroy_schedule = DestroySchedule.new(%{schedule_uuid: uuid})

    with :ok <- Router.dispatch(destroy_schedule, consistency: :strong) do
      {:ok}
    end
  end

  defp matches_created(schedule_uuid) do
    %{ schedule_uuid: schedule_uuid }
    |> IncludeMatchesInSchedule.new()
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
  Update a Team
  """
  def update_team(%{"id" => uuid} = attrs \\ %{}) do
    update_team = 
      attrs
      |> assign(:team_uuid, uuid)
      |> Map.delete("id")
      |> UpdateTeam.new

    with :ok <- Router.dispatch(update_team, consistency: :strong) do
      get(Team, uuid)
    else
      reply -> reply
    end
  end

  @doc """
  Destroy a Team
  """
  def destroy_team(uuid) do
    destroy_team = DestroyTeam.new(%{team_uuid: uuid})

    with :ok <- Router.dispatch(destroy_team, consistency: :strong) do
      :ok
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
  #
  #  Match
  #

  @doc """
  Returns matches by schedule 
  """
  @spec list_matches(params :: map()) :: {matches :: list(Match.t)}
  def list_matches(params \\ %{})
  def list_matches(params) do
    ListMatches.execute(params, Repo)
  end

  @doc """
  Update a Match
  """
  def update_match(%{"id" => uuid} = attrs \\ %{}) do
    update_match = 
      attrs
      |> assign(:match_uuid, uuid)
      |> Map.delete("id")
      |> cast_match_attributes
      |> UpdateMatch.new

    with :ok <- Router.dispatch(update_match, consistency: :strong) do
      get(Match, uuid)
    else
      reply -> reply
    end
  end

  defp cast_match_attributes(%{
    "score_local_team" => score_local_team,
    "score_away_team" => score_away_team,
  } = attrs) do

    %{attrs |
      "score_local_team" => String.to_integer(score_local_team),
      "score_away_team" => String.to_integer(score_away_team),
    }
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
