defmodule Coqueiro.Accounts.Organization do
  use Ecto.Schema
  import Ecto.Changeset

  schema "organizations" do
    field :name, :string
    field :slug, :string
    field :active, :boolean, default: false

    many_to_many :users, Coqueiro.Accounts.User,
      join_through: Coqueiro.Accounts.OrganizationMembership

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(organization, attrs, user_scope) do
    organization
    |> cast(attrs, [:name, :slug, :active])
    |> validate_required([:name, :slug, :active])
    |> put_change(:id, user_scope.user.id)
  end
end
