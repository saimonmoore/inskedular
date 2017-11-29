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
end
