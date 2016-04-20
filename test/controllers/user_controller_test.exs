defmodule TodoApi.UserControllerTest do
  use TodoApi.ConnCase

  alias TodoApi.User
  @valid_attrs %{email: "foo@bar.com", password: "s3cr3t"}
  @invalid_attrs %{}

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  test "creates and renders resource when data is valid", %{conn: conn} do
    conn = post conn, user_path(conn, :create), user: @valid_attrs
    body = json_response(conn, 201)
    assert body["data"]["id"]
    assert body["data"]["email"]
    refute body["data"]["password"]
    assert Repo.get_by(User, email: "foo@bar.com")
  end

  test "does not create resource and renders errors when data is invalid", %{conn: conn} do
    conn = post conn, user_path(conn, :create), user: @invalid_attrs
    body = json_response(conn, 422)
    assert body["errors"] != %{}
  end

end
