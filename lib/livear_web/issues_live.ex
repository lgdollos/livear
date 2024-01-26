defmodule LivearWeb.IssuesLive do
  use LivearWeb, :live_view
  import LivearWeb.IssueHelpers
  alias LivearWeb.IssueSideBar
  alias Livear.Issues

  def mount(%{"filter" => filter}, _session, socket) do
    issues =
      case filter do
        "all" -> Issues.list_issues()
        "active" -> Issues.list_issues(%{status: ["todo", "inprogress"]})
        "backlog" -> Issues.list_issues(%{status: "backlog"})
      end

    socket =
      socket
      |> stream(:issues, issues)
      |> assign(filter: filter)

    {:ok, socket}
  end

  def mount(_params, _session, socket) do
    issues = Issues.list_issues()

    socket =
      socket
      |> stream(:issues, issues)
      |> assign(filter: "all")

    {:ok, socket}
  end

  def render(assigns) do
    ~H"""
    <div class="flex flex-row w-screen bg-zinc-900" id="home">
      <.live_component module={IssueSideBar} id={:side} />
      <.issue_main issues={@streams.issues} filter={@filter} />
    </div>
    """
  end

  def issue_main(assigns) do
    ~H"""
    <div class="lg:w-5/6 sm:w-full max-lg:mx-6 sm:flex flex-col">
      <div class="text-indigo-50 text-sm font-medium h-6 m-6 mt-8 cursor-default">
        <%= issue_top(@filter) %>
      </div>
      <.issue_list issues={@issues} filter={@filter} />
    </div>
    """
  end

  def issue_list(assigns) do
    ~H"""
    <div id="issues" class="border-t border-t-zinc-800" phx-update="stream">
      <.issue_row
        :for={{issue_id, issue} <- @issues}
        issue={issue}
        issue_id={issue_id}
        filter={@filter}
      />
    </div>
    """
  end

  def issue_row(assigns) do
    ~H"""
    <.link id={@issue_id} patch={~p"/issue/#{@issue.id}"}>
      <div class="flex flex-row justify-between py-3 px-6 hover:bg-zinc-800/30 border-b border-b-zinc-800/50">
        <div class="flex flex-row w-1/12 justify-start content-center text-zinc-500 text-sm">
          <.issue_row_priority priority={String.to_atom(@issue.priority)} />
          <.issue_row_name name={@issue.name} />
        </div>
        <div class="flex flex-row w-6/12 content-center ml-2">
          <.issue_row_status status={String.to_atom(@issue.status)} />
          <.issue_row_title title={@issue.title} />
        </div>
        <div class="flex flex-row w-5/12 justify-end content-center align-center text-zinc-500">
          <.issue_row_labels :for={label <- parse_labels(@issue.labels)} label={label} />
          <.issue_row_date date={@issue.inserted_at} />
          <.issue_row_assignee assignee={@issue.assignee} />
        </div>
      </div>
    </.link>
    """
  end

  def issue_row_priority(assigns) do
    ~H"""
    <div class="self-center mr-3">
      <svg
        xmlns="http://www.w3.org/2000/svg"
        fill="none"
        viewBox="0 0 24 24"
        stroke-width="1"
        class="w-4 h-4"
      >
        <path
          stroke-linecap="round"
          stroke-linejoin="round"
          fill={icon_priority(@priority)[:low]}
          }
          d="M3 13.125C3 12.504 3.504 12 4.125 12h2.25c.621 0 1.125.504 1.125 1.125v6.75C7.5 20.496 6.996 21 6.375 21h-2.25A1.125 1.125 0 013 19.875v-6.75z"
        />
        <path
          stroke-linecap="round"
          stroke-linejoin="round"
          fill={icon_priority(@priority)[:medium]}
          }
          d="M9.75 8.625c0-.621.504-1.125 1.125-1.125h2.25c.621 0 1.125.504 1.125 1.125v11.25c0 .621-.504 1.125-1.125 1.125h-2.25a1.125 1.125 0 01-1.125-1.125V8.625z"
        />
        <path
          stroke-linecap="round"
          stroke-linejoin="round"
          fill={icon_priority(@priority)[:high]}
          }
          d="M16.5 4.125c0-.621.504-1.125 1.125-1.125h2.25C20.496 3 21 3.504 21 4.125v15.75c0 .621-.504 1.125-1.125 1.125h-2.25a1.125 1.125 0 01-1.125-1.125V4.125z"
        />
      </svg>
    </div>
    """
  end

  def issue_row_name(assigns) do
    ~H"""
    <div class="self-center hidden lg:flex lg:truncate"><%= @name %></div>
    """
  end

  def issue_row_status(assigns) do
    ~H"""
    <div class="self-center mr-3">
      <svg
        xmlns="http://www.w3.org/2000/svg"
        viewBox="0 0 512 512"
        class={"w-4 h-4 " <> icon_status(@status)[:css]}
      >
        <path d={icon_status(@status)[:path]} />
      </svg>
    </div>
    """
  end

  def issue_row_title(assigns) do
    ~H"""
    <div class="self-center mr-2 font-medium text-indigo-50 text-sm">
      <%= @title %>
    </div>
    """
  end

  def issue_row_labels(assigns) do
    ~H"""
    <div class="flex flex-row content-center rounded-2xl border-[0.5px] border-zinc-700 py-1 pb-1.5 px-3 ml-2 text-xs hidden lg:flex">
      <svg
        xmlns="http://www.w3.org/2000/svg"
        viewBox="0 0 512 512"
        class={"w-2 h-2 mr-2 self-center " <> icon_labels()[@label]}
      >
        <path d="M256 512A256 256 0 1 0 256 0a256 256 0 1 0 0 512z" />
      </svg>
      <span class="hidden lg:flex lg:text-ellipsis overflow-hidden self-center">
        <%= @label %>
      </span>
    </div>
    """
  end

  def issue_row_date(assigns) do
    ~H"""
    <div class="text-xs text-zinc-500 self-center hidden lg:flex lg:truncate mr-2 ml-5">
      <%= name_of_month(@date.month) %> <%= @date.day %>
    </div>
    """
  end

  def issue_row_assignee(assigns) do
    ~H"""
    <div class="self-center p-[0.3rem] bg-teal-700 rounded-full text-white font-medium text-[0.6rem] ml-2">
      <%= @assignee %>
    </div>
    """
  end

  def handle_info({:issue_created, issue}, socket) do
    socket =
      socket
      |> stream_insert(:issues, issue)
      |> put_flash(:new_issue, "#{issue.name} → #{issue.title}")

    {:noreply, socket}
  end
end
