defmodule Coqueiro.Accounts.OrganizationMembership do
  use Ecto.Schema
  import Ecto.Changeset

  schema "organization_memberships" do
    belongs_to :user, Riacho.Accounts.User
    belongs_to :organization, Riacho.Accounts.Organization

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(membership, attrs) do
    membership
    |> cast(attrs, [:user_id, :organization_id])
    |> validate_required([:user_id, :organization_id])
    |> unique_constraint([:user_id, :organization_id])
  end
end
