defmodule Pokestats.RepoCase do
  use ExUnit.CaseTemplate

  using do
    quote do
      alias Pokestats.Repo

      import Ecto
      import Ecto.Query
      import Pokestats.RepoCase

      # and any other stuff
    end
  end

  setup tags do
    :ok = Ecto.Adapters.SQL.Sandbox.checkout(Pokestats.Repo)

    unless tags[:async] do
      Ecto.Adapters.SQL.Sandbox.mode(Pokestats.Repo, {:shared, self()})
    end

    :ok
  end
end
