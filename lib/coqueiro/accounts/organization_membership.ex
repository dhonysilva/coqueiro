defmodule Coqueiro.Accounts.OrganizationMembership do
  use Ecto.Schema
  import Ecto.Changeset

  schema "organization_memberships" do
    belongs_to :user, Riacho.Accounts.User
    belongs_to :organization, Riacho.Accounts.Organization

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(organization_membership, attrs) do
    organization_membership
    |> cast(attrs, [])
    |> validate_required([])

    # |> put_change(:user_id, user_scope.user.id)
  end
end
