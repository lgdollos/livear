defmodule LivearWeb.IssueLive do
  use LivearWeb, :live_view
  import LivearWeb.IssueHelpers
  alias LivearWeb.IssueSideBar
  alias Livear.Issues
  alias Livear.Comment
  alias Livear.Comments

  def mount(_params, _session, socket) do
    changeset = Comments.change_comment(%Comment{}, %{})
    {:ok, assign(socket, form: to_form(changeset))}
  end

  def handle_params(%{"id" => id}, _uri, socket) do
    case Issues.get_issue(id) do
      nil ->
        {:noreply, push_navigate(socket, to: ~p"/issue/#{String.to_integer(id) + 1}")}

      issue ->
        comments = Comments.list_comments(issue.id)

        socket =
          socket
          |> stream(:comments, comments, reset: true)
          |> assign(
            issue: issue,
            id: issue.id,
            name: issue.name,
            title: issue.title,
            detail: issue.detail,
            status: issue.status,
            priority: issue.priority,
            assignee: issue.assignee,
            labels: parse_labels(issue.labels) || []
          )

        {:noreply, socket}

      _ ->
        {:noreply, push_redirect(socket, to: ~p"/")}
    end
  end

  def render(assigns) do
    ~H"""
    <div class="flex flex-row grow sm:w-11/12 bg-zinc-900" }>
      <.live_component module={IssueSideBar} id={:side} url={"issue/#{@id}"} />
      <div class="flex flex-row lg:w-5/6 sm:w-screen">
        <div class="flex flex-col lg:w-5/6 sm:w-full">
          <.topbar name={@name} id={@id} />
          <.issue_details_main
            title={@title}
            detail={@detail}
            comments={@streams.comments}
            id={@id}
            form={@form}
          />
        </div>
        <.issue_details_side
          status={String.to_atom(@status)}
          priority={String.to_atom(@priority)}
          labels={@labels}
          assignee={@assignee}
        />
      </div>
    </div>
    """
  end

  def topbar(assigns) do
    ~H"""
    <div class="flex flex-row justify-between">
      <div class="h-7 m-6 mt-7 cursor-default">
        <.link navigate={~p"/all"}>
          <div class="flex flex-row text-sm">
            <div class="text-zinc-500 border-[0.5px] border-zinc-700/70 hover:border-zinc-600/90 bg-zinc-700/20 rounded-md py-0.5 px-2.5 mr-0.5 flex flex-row">
              <svg
                xmlns="http://www.w3.org/2000/svg"
                viewBox="0 0 20 20"
                fill="currentColor"
                class="w-4 h-4 mr-2 self-center"
              >
                <path d="M2 4.25A2.25 2.25 0 014.25 2h6.5A2.25 2.25 0 0113 4.25V5.5H9.25A3.75 3.75 0 005.5 9.25V13H4.25A2.25 2.25 0 012 10.75v-6.5z" />
                <path d="M9.25 7A2.25 2.25 0 007 9.25v6.5A2.25 2.25 0 009.25 18h6.5A2.25 2.25 0 0018 15.75v-6.5A2.25 2.25 0 0015.75 7h-6.5z" />
              </svg>
              <span>Livear</span>
            </div>
            <span class="text-zinc-400 self-center mt-0.5 mr-0.5">
              <svg
                xmlns="http://www.w3.org/2000/svg"
                viewBox="0 0 20 20"
                fill="currentColor"
                class="w-4 h-4 self-center"
              >
                <path
                  fill-rule="evenodd"
                  d="M7.21 14.77a.75.75 0 01.02-1.06L11.168 10 7.23 6.29a.75.75 0 111.04-1.08l4.5 4.25a.75.75 0 010 1.08l-4.5 4.25a.75.75 0 01-1.06-.02z"
                  clip-rule="evenodd"
                />
              </svg>
            </span>
            <span class="text-indigo-50 self-center"><%= @name %></span>
          </div>
        </.link>
      </div>
      <div class="mt-6 m-4 text-zinc-100 flex flex-row gap-1">
        <.link
          patch={~p"/issue/#{@id - 1}"}
          phx-window-keyup="issue_up_down"
          phx-key="ArrowUp"
          phx-value-id={@id}
        >
          <div class="bg-zinc-800/40 border-[1px] border-zinc-700/50 shadow-md text-zinc-500 rounded-md p-0.5 hover:border-zinc-600/60 hover:text-zinc-400">
            <svg
              xmlns="http://www.w3.org/2000/svg"
              viewBox="0 0 20 20"
              fill="currentColor"
              class="w-5 h-5"
            >
              <path
                fill-rule="evenodd"
                d="M14.77 12.79a.75.75 0 01-1.06-.02L10 8.832 6.29 12.77a.75.75 0 11-1.08-1.04l4.25-4.5a.75.75 0 011.08 0l4.25 4.5a.75.75 0 01-.02 1.06z"
                clip-rule="evenodd"
              />
            </svg>
          </div>
        </.link>
        <.link
          patch={~p"/issue/#{@id + 1}"}
          phx-window-keyup="issue_up_down"
          phx-key="ArrowDown"
          phx-value-id={@id}
        >
          <div class="bg-zinc-800/40 border-[1px] border-zinc-700/50 shadow-md rounded-md text-zinc-500 p-0.5 hover:border-zinc-600/60 hover:text-zinc-400">
            <svg
              xmlns="http://www.w3.org/2000/svg"
              viewBox="0 0 20 20"
              fill="currentColor"
              class="w-5 h-5"
            >
              <path
                fill-rule="evenodd"
                d="M5.23 7.21a.75.75 0 011.06.02L10 11.168l3.71-3.938a.75.75 0 111.08 1.04l-4.25 4.5a.75.75 0 01-1.08 0l-4.25-4.5a.75.75 0 01.02-1.06z"
                clip-rule="evenodd"
              />
            </svg>
          </div>
        </.link>
      </div>
    </div>
    """
  end

  def issue_details_main(assigns) do
    ~H"""
    <div class="sm:w-full pl-14 sm:flex flex-col text-zinc-50 bg-zinc-900 justify-between border-t border-t-zinc-800 ring-0">
      <div class="sm:w-full lg:w-3/4">
        <.input
          name="title"
          value={@title}
          autocomplete="off"
          phx-debounce="2000"
          phx-blur="update_title"
          class="outline-none ring-0 border-zinc-900 border-[1px] -ml-4 pl-5 hover:border-zinc-700 focus:border-zinc-600 text-2xl mt-4 pb-2.5 font-medium placeholder-zinc-500 bg-transparent text-indigo-50"
        />

        <.input
          name="detail"
          value={@detail}
          autocomplete="off"
          phx-debounce="2000"
          phx-blur="update_detail"
          class="outline-none ring-0 border-zinc-900 border-[1px] -ml-4 pl-5 hover:border-zinc-700 focus:border-zinc-600 sm:text-base mt-4 pb-2.5 placeholder-zinc-500 bg-transparent text-indigo-50"
        />
      </div>
      <.comment_section comments={@comments} id={@id} form={@form} />
    </div>
    """
  end

  def issue_details_side(assigns) do
    ~H"""
    <div class="flex flex-col w-1/4 font-medium hidden lg:flex lg:truncate text-sm bg-zinc-800/40 pl-6 pt-0 min-h-screen h-full">
      <.side_top />
      <.side_status status={@status} />
      <.side_priority priority={@priority} />
      <.side_assignee assignee={@assignee} />
      <.side_labels labels={@labels} />
    </div>
    """
  end

  def side_top(assigns) do
    ~H"""
    <div class="h-20 -ml-6 border-b border-b-zinc-700/70 "></div>
    """
  end

  def side_status(assigns) do
    ~H"""
    <div class="flex flex-row my-4 content-center items-center">
      <div class="w-1/3 text-zinc-500 hidden xl:flex">Status</div>
      <div class="self-center mr-2">
        <svg
          xmlns="http://www.w3.org/2000/svg"
          viewBox="0 0 512 512"
          class={"w-6 h-4 " <> icon_status(@status)[:css]}
        >
          <path d={icon_status(@status)[:path]} />
        </svg>
      </div>
      <div class="text-indigo-50 text-sm">
        <.input
          type="select"
          name="status"
          value={@status}
          options={options_status()}
          autocomplete="off"
          phx-debounce="2000"
          phx-focus="update_status"
          class="pl-10 mr-10 -ml-10 my-2 border-none focus:border-zinc-700/70 hover:bg-zinc-700/50 hover:border-1 hover:border-zinc-700 text-indigo-50 text-xs cursor-pointer bg-zinc-800/0"
        />
      </div>
    </div>
    """
  end

  def side_priority(assigns) do
    ~H"""
    <div class="flex flex-row justify-start content-center items-center mb-4">
      <div class="w-1/3 text-zinc-500 hidden xl:flex">Priority</div>
      <div class="self-center mr-3 text-zinc-500">
        <svg
          xmlns="http://www.w3.org/2000/svg"
          fill="none"
          viewBox="0 0 24 24"
          stroke-width="1"
          class="w-5 h-5"
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
      <div class="text-indigo-50 text-sm">
        <.input
          type="select"
          name="priority"
          value={@priority}
          options={options_priority()}
          autocomplete="off"
          phx-debounce="2000"
          phx-focus="update_priority"
          class="pl-10 mr-10 -ml-10 my-2 border-none focus:border-zinc-700/70 hover:bg-zinc-700/50 hover:border-1 hover:border-zinc-700 text-indigo-50 text-xs cursor-pointer bg-zinc-800/0"
        />
      </div>
    </div>
    """
  end

  def side_assignee(assigns) do
    ~H"""
    <div class="flex flex-row content-start justify-start my-4">
      <div class="w-1/3 text-zinc-500 hidden xl:flex">Assignee</div>
      <div class="self-center px-[0.2rem] bg-teal-700 rounded-full text-white font-medium text-[0.6rem] mr-3">
        <%= @assignee %>
      </div>
      <div class="text-indigo-50 text-sm">Mucho Estas</div>
    </div>
    """
  end

  def side_labels(assigns) do
    ~H"""
    <div class="flex flex-row my-4 mt-8">
      <div class="w-1/3 text-zinc-500 hidden xl:flex">Labels</div>
      <div class="w-2/3 ml-0">
        <button
          id="dropdownCheckboxButtonDetails"
          data-dropdown-toggle="dropdownDetailsCheckbox"
          class="w-2/3 inline-flex justify-start items-center self-center cursor-pointer"
          type="button"
        >
          <div class="w-1/2 flex flex-row flex-wrap">
            <div
              :for={label <- @labels}
              class="flex flex-row content-center rounded-2xl border-[0.5px] border-zinc-700 py-1 pb-1.5 px-3 text-xs mr-2 mb-2 hover:border-gray-600"
            >
              <svg
                xmlns="http://www.w3.org/2000/svg"
                viewBox="0 0 512 512"
                class={"w-2 h-2 mr-3 self-center " <> icon_labels()[label]}
              >
                <path d="M256 512A256 256 0 1 0 256 0a256 256 0 1 0 0 512z" />
              </svg>
              <span class="hidden lg:flex lg:text-ellipsis overflow-hidden self-center text-indigo-50">
                <%= label %>
              </span>
            </div>
          </div>
        </button>
      </div>
      <.side_labels_pop labels={@labels} />
    </div>
    """
  end

  def side_labels_pop(assigns) do
    ~H"""
    <div
      id="dropdownDetailsCheckbox"
      class="labels z-10 hidden bg-zinc-800 divide-y divide-gray-100 rounded-lg shadow dark:divide-gray-600 cursor-pointer border-[0.5px] border-zinc-800"
    >
      <ul class="p-3 space-y-3 text-sm text-gray-200" aria-labelledby="dropdownCheckboxButtonDetails">
        <%= for label <- options_label() do %>
          <li>
            <div class="flex items-center">
              <input
                type="checkbox"
                name="labels[]"
                value={label}
                id={label}
                checked={label in @labels}
                phx-click="check_label"
                phx-value-label={label}
                class="w-4 h-4 bg-zinc-700 border-gray-700 rounded cursor-pointer"
              />
              <label for={label} class="ml-2 text-sm text-gray-200 cursor-pointer">
                <%= label %>
              </label>
            </div>
          </li>
        <% end %>
      </ul>
      <input type="hidden" name="labels[]" value="" />
    </div>
    """
  end

  def comment_section(assigns) do
    ~H"""
    <div class="sm:w-full">
      <.comment_stream comments={@comments} />
      <.comment_form id={@id} form={@form} />
    </div>
    """
  end

  def comment_stream(assigns) do
    ~H"""
    <div
      class="border-t border-t-zinc-800 lg:w-3/4 mt-4 py-4 flex flex-col justify-center"
      phx-update="stream"
      id="comment_stream"
    >
      <div :for={{comment_id, comment} <- @comments} class="flex flex-row" id={comment_id}>
        <div class="w-7 h-7 self-center bg-teal-700 rounded-full text-white font-medium text-xs mr-3 flex justify-center">
          <span class="self-center">ME</span>
        </div>
        <div class="bg-zinc-800/40 border-[0.5px] w-11/12 border-zinc-700/50 shadow-md text-indigo-50 p-3 pl-4 mt-4 rounded-lg flex flex-col">
          <div class="text-sm font-medium mb-1">mucho estas</div>
          <div class="h-fit"><%= comment.content %></div>
        </div>
      </div>
    </div>
    """
  end

  def comment_form(assigns) do
    ~H"""
    <div id="#comment-form" class="sm:w-full lg:w-3/4 mb-12">
      <.form for={@form} phx-submit="add_comment" class="flex flex-row">
        <div class="w-7 h-7 self-center bg-teal-700 rounded-full text-white font-medium text-xs mr-4 flex justify-center">
          <span class="self-center">ME</span>
        </div>
        <div class="mt-0 w-11/12 bg-zinc-800/40 border-[0.5px] border-zinc-700/50 shadow-md text-indigo-50 p-3 pr-4 pt-1.5 rounded-lg flex flex-col">
          <div class="h-16 text-base">
            <.input
              type="textarea"
              field={@form[:content]}
              placeholder="Leave a comment"
              autocomplete="off"
              phx-debounce="2000"
              contenteditable="true"
              class="bg-transparent phx-no-feedback:border-none phx-no-feedback:focus:border-none border-none text-indigo-50 rounded-2xl p-2 px-1.5 pt-0 mt-0 text-indigo-50 w-full resize-none"
            />
          </div>
          <.button
            phx-disable-with="Adding..."
            class="bg-zinc-800 hover:bg-zinc-800 text-indigo-50 border-[0.5px] border-zinc-700 rounded-[0.3rem] text-sm shadow-sm drop-shadow cursor-pointer py-[0.2rem] self-end"
          >
            Comment
          </.button>
        </div>
      </.form>
    </div>
    """
  end

  def handle_event("update_title", %{"value" => value}, socket) do
    update_info(:title, value, socket)
  end

  def handle_event("update_detail", %{"value" => value}, socket) do
    update_info(:detail, value, socket)
  end

  def handle_event("update_status", %{"value" => value}, socket) do
    update_info(:status, value, socket)
  end

  def handle_event("update_priority", %{"value" => value}, socket) do
    update_info(:priority, value, socket)
  end

  def update_info(attr, value, socket) do
    Issues.update_issue(socket.assigns.issue, %{attr => value})
    {:noreply, assign(socket, attr, value)}
  end

  def handle_event("check_label", %{"value" => value}, socket) do
    labels =
      Enum.concat(socket.assigns.labels, [value])
      |> Enum.sort()

    update_labels(labels, socket)
  end

  def handle_event("check_label", %{"label" => value}, socket) do
    labels =
      Enum.reject(socket.assigns.labels, &(&1 == value))
      |> Enum.sort()

    update_labels(labels, socket)
  end

  def update_labels(labels, socket) do
    labels_concat = Enum.join(labels, ", ") || ""
    Issues.update_issue(socket.assigns.issue, %{"labels" => labels_concat})
    {:noreply, assign(socket, :labels, labels)}
  end

  def handle_event("add_comment", %{"comment" => comment}, socket) do
    params =
      comment
      |> Map.put("issue_id", socket.assigns.id)
      |> Map.put("type", "comment")

    case Comments.create_comment(params) do
      {:ok, comment} ->
        changeset = Comments.change_comment(%Comment{})

        socket =
          socket
          |> stream_insert(:comments, comment)
          |> assign(:form, to_form(changeset))

        {:noreply, socket}

      {:error, changeset} ->
        {:noreply, assign(socket, form: to_form(changeset))}
    end
  end

  def handle_event("issue_up_down", %{"key" => "ArrowUp", "id" => id}, socket) do
    {:noreply, push_patch(socket, to: ~p"/issue/#{String.to_integer(id) - 1}")}
  end

  def handle_event("issue_up_down", %{"key" => "ArrowDown", "id" => id}, socket) do
    {:noreply, push_patch(socket, to: ~p"/issue/#{String.to_integer(id) + 1}")}
  end

  def handle_info({:issue_created, issue}, socket) do
    {:noreply, put_flash(socket, :new_issue, "#{issue.name} → #{issue.title}")}
  end
end
