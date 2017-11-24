defmodule InskedularWeb.ScheduleControllerTest do
  use InskedularWeb.ConnCase

  import Inskedular.Factory
 
  alias Inskedular.Scheduling
  alias Inskedular.Scheduling.Schedule

  def fixture(:schedule, attrs \\ []) do
    build(:schedule, attrs) |> Scheduling.create_schedule()
  end

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json") }
  end

  describe "create schedule" do
    @tag :web
    test "creates and renders schedule when data is valid", %{conn: conn} do
      conn = post conn, schedule_path(conn, :create), schedule: build(:schedule)
      json = json_response(conn, 201)["data"]

      assert json == %{
        "game_duration"   => 60,
        "name"            => "Hack Week Tournament",
        "number_of_games" => 4,
        "start_date"      => "2017-11-20T12:00:00.000000Z",
        "end_date"        => "2017-12-01T12:00:00.000000Z",
      }
    end

    @tag :web
    test "does not create schedule and renders errors when data is invalid", %{conn: conn} do
      conn = post conn, schedule_path(conn, :create), schedule: build(:schedule, name: "")
      assert json_response(conn, 422)["errors"] == %{
        "name" => [
          "can't be empty",
        ]
      }
    end

    @tag :web
    test "does not create schedule and renders errors when name is taken", %{conn: conn} do
      {:ok, _schedule} = fixture(:schedule)

      conn = post conn, schedule_path(conn, :create), schedule: build(:schedule, name: "Hack Week Tournament")
      assert json_response(conn, 422)["errors"] == %{
        "name" => [
          "has already been taken",
        ]
      }
    end
  end
end
