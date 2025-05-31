defmodule Coqueiro.Scope do
  defstruct id: id

  def for_id(id) do
    %__MODULE__{id: id}
  end
end
