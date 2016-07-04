defmodule Statistics.StatControllerTest do
  use Statistics.ConnCase

  alias Statistics.Stat
  @valid_attrs %{data: %{}, expires_at: %{year: 2015, month: 10, day: 20, hour: 14, min: 0, sec: 0}, key: "some content", project_id: 42, subject_id: 42, subject_set_id: 42, user_id: 42, workflow_id: 42}
  @invalid_attrs %{}

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  test "lists all entries on index", %{conn: conn} do
    conn = get conn, stat_path(conn, :index)
    assert json_response(conn, 200)["data"] == []
  end

  test "shows chosen resource", %{conn: conn} do
    stat = Repo.insert! %Stat{"key" => "foo"}
    conn = get conn, stat_path(conn, :show, stat)
    assert json_response(conn, 200)["data"] == %{"id" => stat.id,
      "key" => stat.key,
      "data" => stat.data,
      "project_id" => stat.project_id,
      "workflow_id" => stat.workflow_id,
      "subject_set_id" => stat.subject_set_id,
      "subject_id" => stat.subject_id,
      "user_id" => stat.user_id,
      "expires_at" => stat.expires_at}
  end

  test "renders page not found when id is nonexistent", %{conn: conn} do
    assert_error_sent 404, fn ->
      get conn, stat_path(conn, :show, -1)
    end
  end

  test "creates and renders resource when data is valid", %{conn: conn} do
    conn = post conn, stat_path(conn, :create), stat: @valid_attrs
    assert json_response(conn, 201)["data"]["id"]
    assert Repo.get_by(Stat, @valid_attrs)
  end

  test "does not create resource and renders errors when data is invalid", %{conn: conn} do
    conn = post conn, stat_path(conn, :create), stat: @invalid_attrs
    assert json_response(conn, 422)["errors"] != %{}
  end

  test "updates and renders chosen resource when data is valid", %{conn: conn} do
    stat = Repo.insert! %Stat{}
    conn = put conn, stat_path(conn, :update, stat), stat: @valid_attrs
    assert json_response(conn, 200)["data"]["id"]
    assert Repo.get_by(Stat, @valid_attrs)
  end

  test "does not update chosen resource and renders errors when data is invalid", %{conn: conn} do
    stat = Repo.insert! %Stat{}
    conn = put conn, stat_path(conn, :update, stat), stat: @invalid_attrs
    assert json_response(conn, 422)["errors"] != %{}
  end

  test "deletes chosen resource", %{conn: conn} do
    stat = Repo.insert! %Stat{}
    conn = delete conn, stat_path(conn, :delete, stat)
    assert response(conn, 204)
    refute Repo.get(Stat, stat.id)
  end
end
