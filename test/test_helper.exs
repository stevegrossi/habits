ExUnit.start

Ecto.Adapters.SQL.Sandbox.mode(Habits.Repo, :manual)

Application.put_env(:wallaby, :base_url, Habits.Endpoint.url)
{:ok, _} = Application.ensure_all_started(:wallaby)
