defmodule Flightex.Users.Agent do
  use Agent

  alias Flightex.Users.User

  def start_link(initial_state) do
    Agent.start_link(fn -> initial_state end, name: __MODULE__)
  end

  def get(cpf), do: Agent.get(__MODULE__, &get_user(&1, cpf))

  def save(%{cpf: cpf} = user) do
    Agent.update(__MODULE__, &update_state(&1, user, cpf))

    {:ok, user}
  end

  defp get_user(state, cpf) do
    case Map.get(state, cpf) do
      nil -> {:error, "User not found"}
      user -> {:ok, user}
    end
  end

  defp update_state(oldState, %User{} = user, cpf) do
    Map.put(oldState, cpf, user)
  end
end
