defmodule TodoApi.TodoControllerTest do
  use TodoApi.ConnCase

  alias TodoApi.Todo
  alias TodoApi.User
  alias TodoApi.Session

  @valid_attrs %{complete: true, description: "some content"}
  @invalid_attrs %{}

  setup %{conn: conn} do
    user = create_user(%{name: "jane"})
    session = create_session(user)

    conn = conn
    |> put_req_header("accept", "application/json")
    |> put_req_header("authorization", "Token token=\"#{session.token}\"")
    {:ok, conn: conn, current_user: user }
  end

  def create_user(%{name: name}) do
    User.changeset(%User{}, %{email: "#{name}@example.com"}) |> Repo.insert!
  end

  def create_session(user) do
    Session.registration_changeset(%Session{user_id: user.id}, %{}) |> Repo.insert!
  end

  def create_todo(%{description: _description, owner_id: _owner_id} = options) do
    Todo.changeset(%Todo{}, options) |> Repo.insert!
  end

  test "lists all entries on index", %{conn: conn, current_user: current_user} do
    create_todo(%{description: "our first todo", owner_id: current_user.id})

    another_user = create_user(%{name: "johndoe"})
    create_todo(%{description: "thier first todo", owner_id: another_user.id})

    conn = get conn, todo_path(conn, :index)

    assert Enum.count(json_response(conn, 200)["data"]) == 1
    assert %{"description" => "our first todo"} = hd(json_response(conn, 200)["data"])
  end

  test "shows chosen resource", %{conn: conn} do
    todo = Repo.insert! %Todo{}
    conn = get conn, todo_path(conn, :show, todo)
    assert json_response(conn, 200)["data"] == %{"id" => todo.id,
      "description" => todo.description,
      "complete" => todo.complete}
  end

  test "does not show resource and instead throw error when id is nonexistent", %{conn: conn} do
    assert_error_sent 404, fn ->
      get conn, todo_path(conn, :show, -1)
    end
  end

  test "creates and renders resource when data is valid", %{conn: conn, current_user: current_user} do
    conn = post conn, todo_path(conn, :create), todo: @valid_attrs
    assert json_response(conn, 201)["data"]["id"]
    todo = Repo.get_by(Todo, @valid_attrs)
    assert todo
    assert todo.owner_id == current_user.id
  end

  test "does not create resource and renders errors when data is invalid", %{conn: conn} do
    conn = post conn, todo_path(conn, :create), todo: @invalid_attrs
    assert json_response(conn, 422)["errors"] != %{}
  end

  test "updates and renders chosen resource when data is valid", %{conn: conn, current_user: current_user} do
    todo = Repo.insert! %Todo{owner_id: current_user.id}
    conn = put conn, todo_path(conn, :update, todo), todo: @valid_attrs
    assert json_response(conn, 200)["data"]["id"]
    assert Repo.get_by(Todo, @valid_attrs)
  end

  test "does not update chosen resource and renders errors when data is invalid", %{conn: conn} do
    todo = Repo.insert! %Todo{}
    conn = put conn, todo_path(conn, :update, todo), todo: @invalid_attrs
    assert json_response(conn, 422)["errors"] != %{}
  end

  test "deletes chosen resource", %{conn: conn} do
    todo = Repo.insert! %Todo{}
    conn = delete conn, todo_path(conn, :delete, todo)
    assert response(conn, 204)
    refute Repo.get(Todo, todo.id)
  end
end
