defmodule Habits.AcceptanceCase do
  use ExUnit.CaseTemplate

  using do
    quote do
      use Wallaby.DSL

      alias Habits.{Factory, Repo}

      import Ecto
      import Ecto.Changeset
      import Ecto.Query
      import Habits.Router.Helpers
      import Wallaby.Query
    end
  end

  setup tags do
    :ok = Ecto.Adapters.SQL.Sandbox.checkout(Habits.Repo)

    unless tags[:async] do
      Ecto.Adapters.SQL.Sandbox.mode(Habits.Repo, {:shared, self()})
    end

    metadata = Phoenix.Ecto.SQL.Sandbox.metadata_for(Habits.Repo, self())
    {:ok, session} = Wallaby.start_session(metadata: metadata)
    {:ok, session: session}
  end
end
