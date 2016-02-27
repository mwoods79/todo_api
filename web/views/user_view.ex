defmodule TodoApi.UserView do
  use TodoApi.Web, :view

  def render("show.json", %{user: user}) do
    %{data: render_one(user, TodoApi.UserView, "user.json")}
  end

  def render("user.json", %{user: user}) do
    %{id: user.id,
      email: user.email}
  end
end
