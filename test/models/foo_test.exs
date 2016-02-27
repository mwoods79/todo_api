defmodule TodoApi.FooTest do
  use TodoApi.ModelCase

  alias TodoApi.Foo

  @valid_attrs %{email: "some content", password: "some content"}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = Foo.changeset(%Foo{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Foo.changeset(%Foo{}, @invalid_attrs)
    refute changeset.valid?
  end
end
