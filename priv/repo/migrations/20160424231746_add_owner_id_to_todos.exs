defmodule TodoApi.Repo.Migrations.AddOwnerIdToTodos do
  use Ecto.Migration

  def change do
    alter table(:todos) do
      add :owner_id, references(:users)
    end
  end
end
