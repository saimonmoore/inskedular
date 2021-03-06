defmodule Inskedular.Scheduling.Aggregates.Match do
  defstruct [
    :uuid,
    :schedule_uuid,
    :status,
    :result,
    :match_number,
    :local_team_uuid,
    :away_team_uuid,
    :score_away_team,
    :score_local_team,
    :start_date,
    :end_date,
  ]

  alias Commanded.Aggregate.Multi
  alias Inskedular.Scheduling.Aggregates.Match
  alias Inskedular.Scheduling.Commands.{CreateMatch,UpdateMatch,DestroyMatch}
  alias Inskedular.Scheduling.Events.{MatchCreated,MatchUpdated,MatchDestroyed}

  @doc """
  Create a new match
  """
  def execute(%Match{uuid: nil}, %CreateMatch{} = create) do
    %MatchCreated{
      match_uuid: create.match_uuid,
      schedule_uuid: create.schedule_uuid,
      match_number: create.match_number,
      local_team_uuid: create.local_team_uuid,
      away_team_uuid: create.away_team_uuid,
      start_date: create.start_date,
      end_date: create.end_date,
    }
  end

  @doc """
  Update a new match
  """
  def execute(%Match{}, %UpdateMatch{} = update) do
    %MatchUpdated{
      schedule_uuid: update.schedule_uuid,
      match_uuid: update.match_uuid,
      status: update.status,
      score_local_team: update.score_local_team,
      score_away_team: update.score_away_team,
      result: update.result,
    }
  end

  def execute(%Match{status: :deleted}, %DestroyMatch{}) do
    {:error, :already_deleted}
  end

  def execute(%Match{}, %DestroyMatch{} = match) do
    %MatchDestroyed{
      match_uuid: match.match_uuid,
      status: "deleted",
    }
  end

  # state mutators

  def apply(%Match{} = match, %MatchCreated{} = created) do
    %Match{match |
      uuid: created.match_uuid,
      schedule_uuid: created.schedule_uuid,
      match_number: created.match_number,
      local_team_uuid: created.local_team_uuid,
      away_team_uuid: created.away_team_uuid,
      start_date: created.start_date,
      end_date: created.end_date,
    }
  end

  def apply(%Match{} = match, %MatchUpdated{} = updated) do
    %Match{match |
      uuid: updated.match_uuid,
      status: updated.status,
      score_local_team: updated.score_local_team,
      score_away_team: updated.score_away_team,
      result: updated.result,
    }
  end

  def apply(%Match{} = match, %MatchDestroyed{} = destroyed) do
    %Match{match |
      uuid: destroyed.match_uuid,
      status: :deleted
    }
  end
end
