defmodule InskedularWeb.ScheduleControllerTest do
  use InskedularWeb.ConnCase

  alias Inskedular.Scheduling
  alias Inskedular.Scheduling.Schedule

  @create_attrs %{end_date: ~N[2010-04-17 14:00:00.000000], game_duration: 42, name: "some name", number_of_games: 42, start_date: ~N[2010-04-17 14:00:00.000000]}
  @update_attrs %{end_date: ~N[2011-05-18 15:01:01.000000], game_duration: 43, name: "some updated name", number_of_games: 43, start_date: ~N[2011-05-18 15:01:01.000000]}
  @invalid_attrs %{end_date: nil, game_duration: nil, name: nil, number_of_games: nil, start_date: nil}

  def fixture(:schedule) do
    {:ok, schedule} = Scheduling.create_schedule(@create_attrs)
    schedule
  end

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all schedules", %{conn: conn} do
      conn = get conn, schedule_path(conn, :index)
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create schedule" do
    test "renders schedule when data is valid", %{conn: conn} do
      conn = post conn, schedule_path(conn, :create), schedule: @create_attrs
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get conn, schedule_path(conn, :show, id)
      assert json_response(conn, 200)["data"] == %{
        "id" => id,
        "end_date" => ~N[2010-04-17 14:00:00.000000],
        "game_duration" => 42,
        "name" => "some name",
        "number_of_games" => 42,
        "start_date" => ~N[2010-04-17 14:00:00.000000]}
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post conn, schedule_path(conn, :create), schedule: @invalid_attrs
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update schedule" do
    setup [:create_schedule]

    test "renders schedule when data is valid", %{conn: conn, schedule: %Schedule{id: id} = schedule} do
      conn = put conn, schedule_path(conn, :update, schedule), schedule: @update_attrs
      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get conn, schedule_path(conn, :show, id)
      assert json_response(conn, 200)["data"] == %{
        "id" => id,
        "end_date" => ~N[2011-05-18 15:01:01.000000],
        "game_duration" => 43,
        "name" => "some updated name",
        "number_of_games" => 43,
        "start_date" => ~N[2011-05-18 15:01:01.000000]}
    end

    test "renders errors when data is invalid", %{conn: conn, schedule: schedule} do
      conn = put conn, schedule_path(conn, :update, schedule), schedule: @invalid_attrs
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete schedule" do
    setup [:create_schedule]

    test "deletes chosen schedule", %{conn: conn, schedule: schedule} do
      conn = delete conn, schedule_path(conn, :delete, schedule)
      assert response(conn, 204)
      assert_error_sent 404, fn ->
        get conn, schedule_path(conn, :show, schedule)
      end
    end
  end

  defp create_schedule(_) do
    schedule = fixture(:schedule)
    {:ok, schedule: schedule}
  end
end
