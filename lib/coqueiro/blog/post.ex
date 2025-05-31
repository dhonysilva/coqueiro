defmodule Coqueiro.Blog.Post do
  use Ecto.Schema
  import Ecto.Changeset

  schema "posts" do
    field :title, :string
    field :session_id, :id

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(post, attrs, session_scope) do
    post
    |> cast(attrs, [:title])
    |> validate_required([:title])
    |> put_change(:session_id, session_scope.id)
  end
end
