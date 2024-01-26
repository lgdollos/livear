defmodule Livear.Comments do
  import Ecto.Query, warn: false
  alias Livear.Comment
  alias Livear.Repo

  def create_comment(attrs \\ %{}) do
    %Comment{}
    |> Comment.changeset(attrs)
    |> Repo.insert()
  end

  def list_comments(issue_id) do
    query =
      from i in Comment,
        where: i.issue_id == ^issue_id,
        order_by: [asc: i.inserted_at]

    Repo.all(query)
  end

  def change_comment(%Comment{} = comment, attrs \\ %{}) do
    Comment.changeset(comment, attrs)
  end
end
