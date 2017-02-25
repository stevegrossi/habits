defmodule Habits.API.V1.AchievementView do
  use Habits.Web, :view

  def render("index.json", %{achievements: achievements}) do
    %{
      achievements: render_many(achievements, __MODULE__, "achievement.json")
    }
  end

  def render("achievement.json", %{achievement: achievement}) do
    %{
      name: achievement.name,
      threshold: achievement.threshold,
      value: achievement.value
    }
  end
end
