defmodule Inskedular.SchedulingTest do
  use Inskedular.DataCase

  alias Inskedular.Scheduling
  alias Inskedular.Scheduling.Projections.Schedule

  setup _context do
    {:ok, start_date, _utc_offset } = DateTime.from_iso8601("2017-11-20T14:00:00.000000+02:00")
    {:ok, end_date, _utc_offset } = DateTime.from_iso8601("2017-12-01T14:00:00.000000+02:00")

    {:ok, [
            start_date: start_date,
            end_date: end_date,
          ]
    }
  end

  describe "list schedules" do
    setup [
      :create_schedules
    ]

    @tag :integration
    test "should list schedules", %{schedules: [schedule1, schedule2]} do
      assert [schedule1, schedule2] == Scheduling.list_schedules()
    end
  end

  describe "create schedule" do
    @tag :integration
    test "succeeds with valid data", context do
      assert {:ok, %Schedule{} = schedule} = Scheduling.create_schedule(build(:schedule))

      assert schedule.name == "Hack Week Tournament"
      assert schedule.number_of_games == 4
      assert schedule.game_duration == 60
      assert schedule.start_date == context[:start_date]
      assert schedule.end_date == context[:end_date]
    end

    @tag :integration
    test "fails with invalid data and return error" do
      assert {:error, :validation_failure, errors} = Scheduling.create_schedule(build(:schedule, name: ""))

      assert errors == %{name: ["can't be empty"]}
    end

    @tag :integration
    test "fails when name already taken and return error" do
      assert {:ok, %Schedule{}} = Scheduling.create_schedule(build(:schedule))
      assert {:error, :validation_failure, errors} = Scheduling.create_schedule(build(:schedule))

      assert errors == %{name: ["has already been taken"]}
    end

    @tag :integration
    test "fails when creating schedules with identical names concurrently and returns error" do
      1..2
      |> Enum.map(fn _ -> Task.async(fn -> Scheduling.create_schedule(build(:schedule)) end) end)
      |> Enum.map(&Task.await/1)
    end
  end

  describe "teams" do
    alias Inskedular.Scheduling.Team

    @valid_attrs %{name: "some name", schedule_uuid: "some schedule_uuid"}
    @update_attrs %{name: "some updated name", schedule_uuid: "some updated schedule_uuid"}
    @invalid_attrs %{name: nil, schedule_uuid: nil}

    def team_fixture(attrs \\ %{}) do
      {:ok, team} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Scheduling.create_team()

      team
    end

    test "list_teams/0 returns all teams" do
      team = team_fixture()
      assert Scheduling.list_teams() == [team]
    end

    test "get_team!/1 returns the team with given id" do
      team = team_fixture()
      assert Scheduling.get_team!(team.id) == team
    end

    test "create_team/1 with valid data creates a team" do
      assert {:ok, %Team{} = team} = Scheduling.create_team(@valid_attrs)
      assert team.name == "some name"
      assert team.schedule_uuid == "some schedule_uuid"
    end

    test "create_team/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Scheduling.create_team(@invalid_attrs)
    end

    test "update_team/2 with valid data updates the team" do
      team = team_fixture()
      assert {:ok, team} = Scheduling.update_team(team, @update_attrs)
      assert %Team{} = team
      assert team.name == "some updated name"
      assert team.schedule_uuid == "some updated schedule_uuid"
    end

    test "update_team/2 with invalid data returns error changeset" do
      team = team_fixture()
      assert {:error, %Ecto.Changeset{}} = Scheduling.update_team(team, @invalid_attrs)
      assert team == Scheduling.get_team!(team.id)
    end

    test "delete_team/1 deletes the team" do
      team = team_fixture()
      assert {:ok, %Team{}} = Scheduling.delete_team(team)
      assert_raise Ecto.NoResultsError, fn -> Scheduling.get_team!(team.id) end
    end

    test "change_team/1 returns a team changeset" do
      team = team_fixture()
      assert %Ecto.Changeset{} = Scheduling.change_team(team)
    end
  end

  describe "matches" do
    alias Inskedular.Scheduling.Match

    @valid_attrs %{away_team_uuid: "some away_team_uuid", end_date: "2010-04-17 14:00:00.000000Z", local_team_uuid: "some local_team_uuid", match_number: 42, match_uuid: "some match_uuid", result: "some result", schedule_uuid: "some schedule_uuid", score_away_team: 42, score_local_team: 42, start_date: "2010-04-17 14:00:00.000000Z", status: "some status"}
    @update_attrs %{away_team_uuid: "some updated away_team_uuid", end_date: "2011-05-18 15:01:01.000000Z", local_team_uuid: "some updated local_team_uuid", match_number: 43, match_uuid: "some updated match_uuid", result: "some updated result", schedule_uuid: "some updated schedule_uuid", score_away_team: 43, score_local_team: 43, start_date: "2011-05-18 15:01:01.000000Z", status: "some updated status"}
    @invalid_attrs %{away_team_uuid: nil, end_date: nil, local_team_uuid: nil, match_number: nil, match_uuid: nil, result: nil, schedule_uuid: nil, score_away_team: nil, score_local_team: nil, start_date: nil, status: nil}

    def match_fixture(attrs \\ %{}) do
      {:ok, match} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Scheduling.create_match()

      match
    end

    test "list_matches/0 returns all matches" do
      match = match_fixture()
      assert Scheduling.list_matches() == [match]
    end

    test "get_match!/1 returns the match with given id" do
      match = match_fixture()
      assert Scheduling.get_match!(match.id) == match
    end

    test "create_match/1 with valid data creates a match" do
      assert {:ok, %Match{} = match} = Scheduling.create_match(@valid_attrs)
      assert match.away_team_uuid == "some away_team_uuid"
      assert match.end_date == DateTime.from_naive!(~N[2010-04-17 14:00:00.000000Z], "Etc/UTC")
      assert match.local_team_uuid == "some local_team_uuid"
      assert match.match_number == 42
      assert match.match_uuid == "some match_uuid"
      assert match.result == "some result"
      assert match.schedule_uuid == "some schedule_uuid"
      assert match.score_away_team == 42
      assert match.score_local_team == 42
      assert match.start_date == DateTime.from_naive!(~N[2010-04-17 14:00:00.000000Z], "Etc/UTC")
      assert match.status == "some status"
    end

    test "create_match/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Scheduling.create_match(@invalid_attrs)
    end

    test "update_match/2 with valid data updates the match" do
      match = match_fixture()
      assert {:ok, match} = Scheduling.update_match(match, @update_attrs)
      assert %Match{} = match
      assert match.away_team_uuid == "some updated away_team_uuid"
      assert match.end_date == DateTime.from_naive!(~N[2011-05-18 15:01:01.000000Z], "Etc/UTC")
      assert match.local_team_uuid == "some updated local_team_uuid"
      assert match.match_number == 43
      assert match.match_uuid == "some updated match_uuid"
      assert match.result == "some updated result"
      assert match.schedule_uuid == "some updated schedule_uuid"
      assert match.score_away_team == 43
      assert match.score_local_team == 43
      assert match.start_date == DateTime.from_naive!(~N[2011-05-18 15:01:01.000000Z], "Etc/UTC")
      assert match.status == "some updated status"
    end

    test "update_match/2 with invalid data returns error changeset" do
      match = match_fixture()
      assert {:error, %Ecto.Changeset{}} = Scheduling.update_match(match, @invalid_attrs)
      assert match == Scheduling.get_match!(match.id)
    end

    test "delete_match/1 deletes the match" do
      match = match_fixture()
      assert {:ok, %Match{}} = Scheduling.delete_match(match)
      assert_raise Ecto.NoResultsError, fn -> Scheduling.get_match!(match.id) end
    end

    test "change_match/1 returns a match changeset" do
      match = match_fixture()
      assert %Ecto.Changeset{} = Scheduling.change_match(match)
    end
  end
end
