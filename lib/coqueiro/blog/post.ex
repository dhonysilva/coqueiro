defmodule Coqueiro.Blog.Post do
  use Ecto.Schema
  import Ecto.Changeset

  schema "posts" do
    field :title, :string
    field :body, :string
    field :org_id, :id

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(post, attrs, organization_scope) do
    post
    |> cast(attrs, [:title, :body])
    |> validate_required([:title, :body])
    |> put_change(:org_id, organization_scope.organization.id)
  end
end
