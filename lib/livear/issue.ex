defmodule Livear.Issue do
  use Ecto.Schema
  import Ecto.Changeset

  schema "issues" do
    field :name, :string
    field :title, :string
    field :detail, :string
    field :status, :string
    field :priority, :string
    field :labels, :string
    field :assignee, :string
    field :target_date, :date

    timestamps()
  end

  def changeset(issue, attrs) do
    issue
    |> cast(attrs, [:name, :title, :detail, :status, :priority, :labels, :assignee])
    |> validate_required([:title, :detail, :status, :priority])
  end
end
