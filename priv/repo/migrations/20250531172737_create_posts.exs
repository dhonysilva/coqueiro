defmodule Coqueiro.Repo.Migrations.CreatePosts do
  use Ecto.Migration

  def change do
    create table(:posts) do
      add :title, :string
      add :session_id, :bigint

      timestamps(type: :utc_datetime)
    end

    create index(:posts, [:session_id])
  end
end
