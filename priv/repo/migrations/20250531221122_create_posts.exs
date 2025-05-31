defmodule Coqueiro.Repo.Migrations.CreatePosts do
  use Ecto.Migration

  # mix phx.gen.live Blog Post posts title:string body:text

  def change do
    create table(:posts) do
      add :title, :string
      add :body, :text
      add :user_id, references(:users, type: :id, on_delete: :delete_all)

      timestamps(type: :utc_datetime)
    end

    create index(:posts, [:user_id])
  end
end
