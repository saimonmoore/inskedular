defmodule Inskedular.SchedulingTest do
  use Inskedular.DataCase

  alias Inskedular.Scheduling

  describe "schedules" do
    alias Inskedular.Scheduling.Schedule

    @valid_attrs %{end_date: ~N[2010-04-17 14:00:00.000000], game_duration: 42, name: "some name", number_of_games: 42, start_date: ~N[2010-04-17 14:00:00.000000]}
    @update_attrs %{end_date: ~N[2011-05-18 15:01:01.000000], game_duration: 43, name: "some updated name", number_of_games: 43, start_date: ~N[2011-05-18 15:01:01.000000]}
    @invalid_attrs %{end_date: nil, game_duration: nil, name: nil, number_of_games: nil, start_date: nil}

    def schedule_fixture(attrs \\ %{}) do
      {:ok, schedule} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Scheduling.create_schedule()

      schedule
    end

    test "list_schedules/0 returns all schedules" do
      schedule = schedule_fixture()
      assert Scheduling.list_schedules() == [schedule]
    end

    test "get_schedule!/1 returns the schedule with given id" do
      schedule = schedule_fixture()
      assert Scheduling.get_schedule!(schedule.id) == schedule
    end

    test "create_schedule/1 with valid data creates a schedule" do
      assert {:ok, %Schedule{} = schedule} = Scheduling.create_schedule(@valid_attrs)
      assert schedule.end_date == ~N[2010-04-17 14:00:00.000000]
      assert schedule.game_duration == 42
      assert schedule.name == "some name"
      assert schedule.number_of_games == 42
      assert schedule.start_date == ~N[2010-04-17 14:00:00.000000]
    end

    test "create_schedule/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Scheduling.create_schedule(@invalid_attrs)
    end

    test "update_schedule/2 with valid data updates the schedule" do
      schedule = schedule_fixture()
      assert {:ok, schedule} = Scheduling.update_schedule(schedule, @update_attrs)
      assert %Schedule{} = schedule
      assert schedule.end_date == ~N[2011-05-18 15:01:01.000000]
      assert schedule.game_duration == 43
      assert schedule.name == "some updated name"
      assert schedule.number_of_games == 43
      assert schedule.start_date == ~N[2011-05-18 15:01:01.000000]
    end

    test "update_schedule/2 with invalid data returns error changeset" do
      schedule = schedule_fixture()
      assert {:error, %Ecto.Changeset{}} = Scheduling.update_schedule(schedule, @invalid_attrs)
      assert schedule == Scheduling.get_schedule!(schedule.id)
    end

    test "delete_schedule/1 deletes the schedule" do
      schedule = schedule_fixture()
      assert {:ok, %Schedule{}} = Scheduling.delete_schedule(schedule)
      assert_raise Ecto.NoResultsError, fn -> Scheduling.get_schedule!(schedule.id) end
    end

    test "change_schedule/1 returns a schedule changeset" do
      schedule = schedule_fixture()
      assert %Ecto.Changeset{} = Scheduling.change_schedule(schedule)
    end
  end
end
