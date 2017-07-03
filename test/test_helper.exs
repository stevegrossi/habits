ExUnit.start

Ecto.Adapters.SQL.Sandbox.mode(Habits.Repo, :manual)

Application.put_env(:wallaby, :base_url, Habits.Endpoint.url)
Application.put_env(:wallaby, :js_errors, false)
{:ok, _} = Application.ensure_all_started(:wallaby)
