defmodule Livear.Repo.Migrations.CreateComments do
  use Ecto.Migration

  def change do
    create table(:comments) do
      add :content, :string
      add :type, :string
      add :issue_id, references(:issues, on_delete: :nothing)

      timestamps()
    end

    create index(:comments, [:issue_id])
  end
end
