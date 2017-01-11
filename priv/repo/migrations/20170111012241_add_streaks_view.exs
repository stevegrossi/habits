defmodule Habits.Repo.Migrations.AddStreaksView do
  use Ecto.Migration

  def up do
    execute """
    CREATE VIEW streaks AS
      WITH start_streak AS (
        SELECT
          check_ins.date,
          check_ins.habit_id,
          CASE WHEN check_ins.date - LAG(check_ins.date, 1) OVER (PARTITION BY check_ins.habit_id ORDER BY check_ins.date) > 1
            THEN 1
            ELSE 0
          END streak_start
        FROM check_ins
        ),
        streak_groups AS (
          SELECT
            date,
            habit_id,
            SUM(streak_start) over (PARTITION BY habit_id ORDER BY date) streak
          FROM start_streak
        )
      SELECT
        habit_id,
        MIN(date) AS start,
        MAX(date) AS end,
        MAX(date) - MIN(date) + 1 AS length
      FROM streak_groups
      GROUP BY habit_id, streak
    ;
    """
  end

  def down do
    execute "DROP VIEW streaks;"
  end
end
