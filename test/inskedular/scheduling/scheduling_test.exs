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

  describe "create schedule" do
    @tag :integration
    test "should succeed with valid data", context do
      assert {:ok, %Schedule{} = schedule} = Scheduling.create_schedule(build(:schedule))

      assert schedule.name == "Hack Week Tournament"
      assert schedule.number_of_games == 4
      assert schedule.game_duration == 60
      assert schedule.start_date == context[:start_date]
      assert schedule.end_date == context[:end_date]
    end
  end
end
