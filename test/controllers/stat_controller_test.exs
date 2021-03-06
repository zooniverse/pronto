defmodule Pronto.StatControllerTest do
  use Pronto.ConnCase

  alias Pronto.Stat
  @valid_attrs %{data: %{"foo" => 1},
                 expires_at: %{year: 2015, month: 10, day: 20, hour: 14, minute: 0, second: 0},
                 key: "some content",
                 project_id: 42}
  @invalid_attrs %{}
  @user %{
    "id" => 299778,
    "dname" => "martenveldthuis", 
    "login" => "martenveldthuis",
    "admin" => false, 
    "scope" => ["public", "user", "project", "group", "collection", "classification", "subject", "medium"]
  }

  setup :accept_json
  
  describe "GET /stats/:key" do
    test "lists all entries on index", %{conn: conn} do
      conn = get conn, stat_path(conn, :index, "key")
      assert json_response(conn, 200)["data"] == []
    end

    test "returns existing entries", %{conn: conn} do
      stat = Repo.insert! %Stat{key: "FOO", data: %{}}
      conn = get conn, stat_path(conn, :index, stat.key)
      assert json_response(conn, 200)["data"] == [%{
          "key" => stat.key,
          "data" => stat.data,
          "project_id" => stat.project_id,
          "workflow_id" => stat.workflow_id,
          "subject_set_id" => stat.subject_set_id,
          "subject_id" => stat.subject_id,
          "user_id" => stat.user_id,
          "expires_at" => stat.expires_at
        }]
    end
  end

  describe "POST /stats/:key with correct permissions" do
    setup :admin_user

    test "creates and renders resource when data is valid", %{conn: conn} do
      conn = post conn, stat_path(conn, :upsert, "key"), stat: @valid_attrs
      assert json_response(conn, 201)["data"]["key"]
      assert Repo.get_by(Stat, @valid_attrs)
    end

    test "does not create resource and renders errors when data is invalid", %{conn: conn} do
      conn = post conn, stat_path(conn, :upsert, "key"), stat: @invalid_attrs
      assert json_response(conn, 422)["errors"] != %{}
    end

    test "updates an existing record", %{conn: conn} do
      stat = Repo.insert! %Stat{key: @valid_attrs.key, data: %{}, project_id: @valid_attrs.project_id}

      conn = post conn, stat_path(conn, :upsert, stat.key), stat: @valid_attrs
      assert json_response(conn, 201)["data"]["key"]

      conn = get conn, stat_path(conn, :index, stat.key)
      assert json_response(conn, 200)["data"] == [%{
          "key" => @valid_attrs.key,
          "data" => @valid_attrs.data,
          "project_id" => @valid_attrs.project_id,
          "workflow_id" => nil,
          "subject_set_id" => nil,
          "subject_id" => nil,
          "user_id" => nil,
          "expires_at" => "2015-10-20T14:00:00"
        }]
    end
  end

  describe "POST /stats/:key when the user isn't an admin" do
    setup :non_admin_user

    test "returns a forbidden status", %{conn: conn} do
      conn = post conn, stat_path(conn, :upsert, "key"), stat: @valid_attrs
      assert response(conn, 403)
    end
  end

  describe "DELETE /stats/:key with correct permissions" do
    setup :admin_user

    test "deletes chosen resource", %{conn: conn} do
      stat = Repo.insert! %Stat{key: "FOO", data: %{}}
      conn = delete conn, stat_path(conn, :delete, stat.key)
      assert response(conn, 204)
      refute Repo.get(Stat, stat.id)
    end
  end

  describe "DELETE /stats/:key when the user isn't an admin" do
    setup :non_admin_user

    test "deletes chosen resource", %{conn: conn} do
      stat = Repo.insert! %Stat{key: "FOO", data: %{}}
      conn = delete conn, stat_path(conn, :delete, stat.key)
      assert response(conn, 403)
    end
  end

  def accept_json(%{conn: conn}) do
    {:ok, conn: conn |> put_req_header("accept", "application/json")}
  end

  def admin_user(%{conn: conn}) do
    user = Map.put(@user, "admin", true)
    {:ok, conn: conn |> put_req_header("authorization", "Bearer " <> get_jwt(user))}
  end

  def non_admin_user(%{conn: conn}) do
    user = Map.put(@user, "admin", false)
    {:ok, conn: conn |> put_req_header("authorization", "Bearer " <> get_jwt(user))}
  end

  def get_jwt(data) do
    {:ok, jwt, _encoded_claims} = Guardian.encode_and_sign(%{}, :token, %{"data" => data})
    jwt
  end
end
