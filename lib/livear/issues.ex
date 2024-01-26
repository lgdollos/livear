defmodule Livear.Issues do
  import Ecto.Query, warn: false
  alias Livear.Issue
  alias Livear.Repo

  def create_issue(attrs \\ %{}) do
    %Issue{}
    |> Issue.changeset(attrs)
    |> Repo.insert()
  end

  def list_issues do
    query = from i in Issue, order_by: [asc: i.inserted_at]
    Repo.all(query)
  end

  def count_issues do
    length(Repo.all(Issue))
  end

  def get_issue!(id) do
    Repo.get!(Issue, id)
  end

  def get_issue(id) do
    Repo.get(Issue, id)
  end

  def update_issue(%Issue{} = issue, attrs) do
    issue
    |> Issue.changeset(attrs)
    |> Repo.update()
  end

  def change_issue(%Issue{} = issue, attrs \\ %{}) do
    Issue.changeset(issue, attrs)
  end

  def list_issues(filter) when is_map(filter) do
    Issue
    |> filter_by_status(filter)
    |> order_by([i], asc: i.inserted_at)
    |> Repo.all()
  end

  defp filter_by_status(query, %{status: [""]}), do: query

  defp filter_by_status(query, %{status: status}) when is_list(status) do
    where(query, [issue], issue.status in ^status)
  end

  defp filter_by_status(query, %{status: ""}), do: query

  defp filter_by_status(query, %{status: status}) when is_bitstring(status) do
    where(query, status: ^status)
  end
end
