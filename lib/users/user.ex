defmodule Flightex.Users.User do
  @keys [:name, :email, :cpf, :id]
  @enforce_keys @keys
  defstruct @keys

  def build(name, email, cpf) do
    response = %__MODULE__{
      name: name,
      email: email,
      cpf: cpf,
      id: UUID.uuid4()
    }

    {:ok, response}
  end
end
