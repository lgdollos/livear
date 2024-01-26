defmodule LivearWeb.IssueSideBar do
  use LivearWeb, :live_component
  import LivearWeb.IssueHelpers
  alias Livear.Issue
  alias Livear.Issues
  alias Phoenix.LiveView.JS

  def mount(socket) do
    changeset = Issues.change_issue(%Issue{})
    {:ok, assign(socket, form: to_form(changeset))}
  end

  def render(assigns) do
    ~H"""
    <div class="pl-2 w-1/6 border-r border-r-zinc-800 hidden lg:flex flex-col" id="side">
      <.new_issue_btn />
      <.new_issue_modal form={@form} />
      <.issue_filter />
    </div>
    """
  end

  def new_issue_btn(assigns) do
    ~H"""
    <div class="mt-20">
      <.button
        phx-click={show_modal("issue-modal")}
        phx-window-keyup={show_modal("issue-modal")}
        phx-key="+"
        phx-disable-with="Adding..."
        class="flex flex-row justify-between content-center align-center m-4 bg-zinc-800 hover:bg-zinc-800 text-indigo-50 lg:w-32 xl:w-48 border-[0.5px] text-left border-zinc-700 rounded-[0.3rem] pt-[0.3rem] pb-[0.4rem] px-2 hover:border-zinc-600 shadow-sm drop-shadow cursor-pointer mt-0"
      >
        <div class="flex flex-row gap-2">
          <svg
            xmlns="http://www.w3.org/2000/svg"
            viewBox="0 0 20 20"
            fill="currentColor"
            class="w-4 h-4 mt-0.5"
          >
            <path d="M5.433 13.917l1.262-3.155A4 4 0 017.58 9.42l6.92-6.918a2.121 2.121 0 013 3l-6.92 6.918c-.383.383-.84.685-1.343.886l-3.154 1.262a.5.5 0 01-.65-.65z" />
            <path d="M3.5 5.75c0-.69.56-1.25 1.25-1.25H10A.75.75 0 0010 3H4.75A2.75 2.75 0 002 5.75v9.5A2.75 2.75 0 004.75 18h9.5A2.75 2.75 0 0017 15.25V10a.75.75 0 00-1.5 0v5.25c0 .69-.56 1.25-1.25 1.25h-9.5c-.69 0-1.25-.56-1.25-1.25v-9.5z" />
          </svg>
          <span class="text-sm font-medium">New issue</span>
        </div>
        <div class="text-zinc-400 border-[0.85px] border-zinc-500/80 bg-zinc-700/20 rounded-sm text-xs self-center px-1">
          +
        </div>
      </.button>
    </div>
    """
  end

  def new_issue_modal(assigns) do
    ~H"""
    <.modal
      id="issue-modal"
      class="shadow-none p-0 m-0 w-[54rem] -top-60 border-none shadow-none ring-offset-0 bg-transparent ring-transparent"
    >
      <.issue_form form={@form} />
    </.modal>
    """
  end

  def issue_form(assigns) do
    ~H"""
    <div
      id="issue-form"
      class="flex flex-col m-4 py-4 shadow-lg rounded-md border-[0.8px] border-zinc-700 bg-zinc-800 drop-shadow-lg"
    >
      <.form for={@form} phx-submit="save" phx-target="#issue-form">
        <div class="flex flex-col px-2 text-sm cursor-default">
          <.issue_form_top />
          <.issue_form_details form={@form} />
        </div>
        <.issue_form_selects form={@form} />
        <div class="flex flex-row justify-end px-4">
          <.button
            phx-disable-with="Adding..."
            class="dark:bg-indigo-500 rounded-[0.3rem] pt-[0.25rem] pb-[0.3rem] px-5 dark:hover:bg-indigo-600 text-sm"
          >
            Create issue
          </.button>
        </div>
      </.form>
    </div>
    """
  end

  def issue_form_top(assigns) do
    ~H"""
    <div class="ml-3 mb-2 flex flex-row content-center">
      <div class="text-zinc-500 border-[0.5px] border-zinc-700/70 bg-zinc-700/20 rounded-md py-0.5 px-2.5 mr-0.5 flex flex-row">
        <svg
          xmlns="http://www.w3.org/2000/svg"
          viewBox="0 0 20 20"
          fill="currentColor"
          class="w-4 h-4 mr-2 self-center"
        >
          <path d="M2 4.25A2.25 2.25 0 014.25 2h6.5A2.25 2.25 0 0113 4.25V5.5H9.25A3.75 3.75 0 005.5 9.25V13H4.25A2.25 2.25 0 012 10.75v-6.5z" />
          <path d="M9.25 7A2.25 2.25 0 007 9.25v6.5A2.25 2.25 0 009.25 18h6.5A2.25 2.25 0 0018 15.75v-6.5A2.25 2.25 0 0015.75 7h-6.5z" />
        </svg>
        <span>LVR</span>
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
      <span class="text-indigo-50 self-center"> New Issue </span>
    </div>
    """
  end

  def issue_form_details(assigns) do
    ~H"""
    <div>
      <.input
        field={@form[:title]}
        placeholder="Issue Title"
        autocomplete="off"
        phx-debounce="2000"
        class="border-none sm:text-lg font-medium placeholder-zinc-500 bg-transparent text-indigo-100"
      />

      <.input
        field={@form[:detail]}
        placeholder="Add description"
        autocomplete="off"
        phx-debounce="2000"
        class="border-none sm:text-base placeholder-zinc-500 bg-transparent text-indigo-50"
      />
    </div>
    """
  end

  def issue_form_selects(assigns) do
    ~H"""
    <div class="flex flex-row justify-normal gap-x-2 content-center items-center my-4 pb-4 px-4 border-b-[0.5px] border-b-zinc-700 ">
      <.input
        type="select"
        field={@form[:status]}
        options={options_status()}
        autocomplete="off"
        phx-debounce="2000"
        class="border-zinc-700/70 focus:border-zinc-800 py-1 px-3 text-gray-200 text-xs cursor-pointer bg-zinc-700/20"
      />

      <.input
        type="select"
        field={@form[:priority]}
        options={options_priority()}
        autocomplete="off"
        phx-debounce="2000"
        class="border-zinc-700/70 focus:border-zinc-800 py-1 text-gray-200 text-xs cursor-pointer bg-zinc-700/20"
      />

      <.labels_group />
    </div>
    """
  end

  def issue_filter(assigns) do
    ~H"""
    <div class="flex flex-col font-medium text-sm justify-evenly mt-14 ml-4 mr-6 text-indigo-50">
      <div
        class="mb-1 p-1 pb-1.5 pl-4 hover:bg-zinc-800 hover:rounded-md flex flex-row cursor-pointer"
        phx-click={toggle_side()}
      >
        <svg
          xmlns="http://www.w3.org/2000/svg"
          viewBox="0 0 20 20"
          fill="currentColor"
          class="w-4 h-4 mr-2 self-center"
        >
          <path d="M2 4.25A2.25 2.25 0 014.25 2h6.5A2.25 2.25 0 0113 4.25V5.5H9.25A3.75 3.75 0 005.5 9.25V13H4.25A2.25 2.25 0 012 10.75v-6.5z" />
          <path d="M9.25 7A2.25 2.25 0 007 9.25v6.5A2.25 2.25 0 009.25 18h6.5A2.25 2.25 0 0018 15.75v-6.5A2.25 2.25 0 0015.75 7h-6.5z" />
        </svg>
        <span class="">Livear</span>
        <svg
          xmlns="http://www.w3.org/2000/svg"
          viewBox="0 0 320 512"
          class="h-[0.8rem] ml-2 mt-1 fill-zinc-400 ease-in-out duration-300"
          id="caret"
        >
          <path d="M137.4 374.6c12.5 12.5 32.8 12.5 45.3 0l128-128c9.2-9.2 11.9-22.9 6.9-34.9s-16.6-19.8-29.6-19.8L32 192c-12.9 0-24.6 7.8-29.6 19.8s-2.2 25.7 6.9 34.9l128 128z" />
        </svg>
      </div>
      <div id="filters">
        <.link navigate={~p"/all"}>
          <div class="mt-1 p-1 pb-1.5 pl-7 hover:bg-zinc-800 hover:rounded-md flex flex-row content-center">
            <svg
              xmlns="http://www.w3.org/2000/svg"
              viewBox="0 0 20 20"
              fill="currentColor"
              class="w-4 h-4 mr-2 self-center"
            >
              <path d="M5.127 3.502L5.25 3.5h9.5c.041 0 .082 0 .123.002A2.251 2.251 0 0012.75 2h-5.5a2.25 2.25 0 00-2.123 1.502zM1 10.25A2.25 2.25 0 013.25 8h13.5A2.25 2.25 0 0119 10.25v5.5A2.25 2.25 0 0116.75 18H3.25A2.25 2.25 0 011 15.75v-5.5zM3.25 6.5c-.04 0-.082 0-.123.002A2.25 2.25 0 015.25 5h9.5c.98 0 1.814.627 2.123 1.502a3.819 3.819 0 00-.123-.002H3.25z" />
            </svg>

            <span class="self-center">Issues</span>
          </div>
        </.link>
        <.link navigate={~p"/active"}>
          <div
            class="ml-10 mt-1 p-1 pb-1.5 pl-4 hover:bg-zinc-800 hover:rounded-md cursor-pointer"
            value="status"
          >
            Active
          </div>
        </.link>
        <.link navigate={~p"/backlog"}>
          <div class="ml-10 mt-1 p-1 pb-1.5 pl-4 hover:bg-zinc-800 hover:rounded-md cursor-pointer">
            Backlog
          </div>
        </.link>
      </div>
    </div>
    """
  end

  def labels_group(assigns) do
    ~H"""
    <.labels_group_button />
    <.labels_group_dropdown />
    """
  end

  def labels_group_button(assigns) do
    ~H"""
    <button
      id="dropdownCheckboxButton"
      data-dropdown-toggle="dropdownDefaultCheckbox"
      class="text-gray-200 border-[1px] shadow-sm border-zinc-700/70 bg-zinc-700/20 rounded-md text-sm px-3 py-1 mt-2 h-7.5 inline-flex justify-start items-center hover:bg-zinc-700/30 hover:border-zinc-700/80 self-center cursor-pointer"
      type="button"
    >
      Label
      <svg
        class="w-2.5 h-2.5 ml-2.5"
        aria-hidden="true"
        xmlns="http://www.w3.org/2000/svg"
        fill="none"
        viewBox="0 0 10 6"
      >
        <path
          stroke="#6C727F"
          stroke-linecap="round"
          stroke-linejoin="round"
          stroke-width="1.5"
          d="m1 1 4 4 4-4"
        />
      </svg>
    </button>
    """
  end

  def labels_group_dropdown(assigns) do
    ~H"""
    <div
      id="dropdownDefaultCheckbox"
      class="labels z-10 hidden bg-zinc-800 divide-y divide-gray-100 rounded-lg shadow dark:divide-gray-600 cursor-pointer border-[0.5px] border-zinc-800"
    >
      <ul class="p-3 space-y-3 text-sm text-gray-200" aria-labelledby="dropdownCheckboxButton">
        <%= for label <- options_label() do %>
          <li>
            <div class="flex items-center">
              <input
                type="checkbox"
                name="labels[]"
                value={label}
                id={label}
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

  def handle_event("save", %{"issue" => params, "labels" => labels}, socket) do
    issue_params = new_issue(params, labels)

    case Issues.create_issue(issue_params) do
      {:ok, issue} ->
        send(self(), {:issue_created, issue})
        changeset = Issues.change_issue(%Issue{})

        socket =
          socket
          |> assign(:form, to_form(changeset))
          |> push_event("js-exec", %{to: "#issue-modal", attr: "phx-remove"})

        {:noreply, socket}

      {:error, changeset} ->
        {:noreply, assign(socket, form: to_form(changeset))}
    end
  end

  defp new_issue(params, labels) do
    name = "LVR-" <> to_string(Issues.count_issues() + 1)
    labels_concat = Enum.join(labels, ", ") || ""

    params
    |> Map.put("name", name)
    |> Map.put("labels", labels_concat)
    |> Map.put("assignee", "ME")
  end

  def toggle_side do
    JS.add_class(
      "-rotate-90",
      to: "#caret:not(.-rotate-90)"
    )
    |> JS.remove_class(
      "-rotate-90",
      to: "#caret.-rotate-90"
    )
    |> JS.toggle(
      to: "#filters",
      in: {"ease-in-out duration-300", "opacity-0", "opacity-100"},
      out: {"ease-in-out duration-200", "opacity-100", "opacity-0"}
    )
  end
end
