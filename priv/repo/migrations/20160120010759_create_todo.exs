defmodule TodoApi.Repo.Migrations.CreateTodo do
  use Ecto.Migration

  def change do
    create table(:todos) do
      add :description, :string
      add :complete, :boolean, default: false

      timestamps
    end

  end
end
