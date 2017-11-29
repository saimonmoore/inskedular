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
end
