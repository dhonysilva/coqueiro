defmodule Coqueiro.Repo.Migrations.CreateOrganizationMemberships do
  use Ecto.Migration

  def change do
    create table(:organization_memberships) do
      add :user_id, references(:users, on_delete: :nothing)
      add :organization_id, references(:organizations, on_delete: :nothing)

      timestamps(type: :utc_datetime)
    end

    create unique_index(:organization_memberships, [:user_id, :organization_id])
    create index(:organization_memberships, [:organization_id])
    create index(:organization_memberships, [:user_id])
  end
end
