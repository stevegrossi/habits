defmodule Habits.Achievements.Achievement do
  @doc """
  Shared behaviour for individual Achievement modules which `use Achievement`
  """
  defmacro __using__(_) do
    quote do
      @enforce_keys ~w(name threshold value)a
      defstruct ~w(name threshold value)a

      @callback value_for(any) :: number

      def new(subject, threshold, name) do
        %__MODULE__{
          name: name,
          threshold: threshold,
          value: value_for(subject)
        }
      end
    end
  end
end
