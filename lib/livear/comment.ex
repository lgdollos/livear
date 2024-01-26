defmodule Livear.Comment do
  use Ecto.Schema
  import Ecto.Changeset

  schema "comments" do
    field :type, :string
    field :content, :string
    field :issue_id, :id

    timestamps()
  end

  @doc false
  def changeset(comment, attrs) do
    comment
    |> cast(attrs, [:content, :type, :issue_id])
    |> validate_required([:content])
  end
end
