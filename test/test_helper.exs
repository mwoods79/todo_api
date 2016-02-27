ExUnit.start

Mix.Task.run "ecto.create", ~w(-r TodoApi.Repo --quiet)
Mix.Task.run "ecto.migrate", ~w(-r TodoApi.Repo --quiet)
Ecto.Adapters.SQL.begin_test_transaction(TodoApi.Repo)

