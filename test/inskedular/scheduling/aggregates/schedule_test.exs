defmodule Inskedular.Scheduling.Aggregates.ScheduleTest do
  use Inskedular.AggregateCase, aggregate: Inskedular.Scheduling.Aggregates.Schedule

  alias Inskedular.Scheduling.Commands.CreateSchedule
  alias Inskedular.Scheduling.Events.ScheduleCreated

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
    @tag :unit
    test "should succeed when valid", context do
      schedule_uuid = UUID.uuid4()

      assert_events build(:create_schedule, schedule_uuid: schedule_uuid), [
        %ScheduleCreated{
          schedule_uuid: schedule_uuid,
          name: "Hack Week Tournament",
          number_of_games: 4,
          game_duration: 60,
          start_date: context[:start_date],
          end_date: context[:end_date],
        }
      ]
    end
  end
end
