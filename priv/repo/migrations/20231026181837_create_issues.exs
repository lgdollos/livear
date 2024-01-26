defmodule Livear.Repo.Migrations.CreateIssues do
  use Ecto.Migration

  def change do
    create table(:issues) do
      add :name, :string
      add :title, :string
      add :detail, :string
      add :status, :string
      add :priority, :string
      add :labels, :string
      add :assignee, :string
      add :target_date, :date

      timestamps()
    end
  end
end
