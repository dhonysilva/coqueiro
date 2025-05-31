defmodule Coqueiro.Scope do
  defstruct id: nil

  def for_id(id) do
    %__MODULE__{id: id}
  end
end
