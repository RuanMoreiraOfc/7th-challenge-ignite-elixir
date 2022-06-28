defmodule Flightex.Users.CreateOrUpdate do
  alias Flightex.Users.{Agent, User}

  def call(%{cpf: cpf}) when not is_binary(cpf) do
    {:error, "Cpf must be a String"}
  end

  def call(%{
        name: name,
        email: email,
        cpf: cpf
      }) do
    {:ok, user} = User.build(name, email, cpf)

    Agent.save(user)
  end
end
