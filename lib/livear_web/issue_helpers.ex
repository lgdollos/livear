defmodule LivearWeb.IssueHelpers do
  def options_status do
    [
      Backlog: :backlog,
      Todo: :todo,
      "In Progress": :inprogress,
      Done: :done,
      Cancelled: :cancelled,
      Duplicate: :duplicate
    ]
  end

  def options_priority do
    [
      "No Priority": :nopriority,
      Low: :low,
      Medium: :medium,
      High: :high
    ]
  end

  def options_label, do: ["Bug", "Feature", "Improvement"]

  def icon_status(status), do: icon_status_svg()[status]

  def icon_status_svg do
    %{
      backlog: %{
        path:
          "M304 48a48 48 0 1 0 -96 0 48 48 0 1 0 96 0zm0 416a48 48 0 1 0 -96 0 48 48 0 1 0 96 0zM48 304a48 48 0 1 0 0-96 48 48 0 1 0 0 96zm464-48a48 48 0 1 0 -96 0 48 48 0 1 0 96 0zM142.9 437A48 48 0 1 0 75 369.1 48 48 0 1 0 142.9 437zm0-294.2A48 48 0 1 0 75 75a48 48 0 1 0 67.9 67.9zM369.1 437A48 48 0 1 0 437 369.1 48 48 0 1 0 369.1 437z",
        css: "fill-gray-400"
      },
      todo: %{
        path:
          "M464 256A208 208 0 1 0 48 256a208 208 0 1 0 416 0zM0 256a256 256 0 1 1 512 0A256 256 0 1 1 0 256z",
        css: "fill-indigo-50"
      },
      inprogress: %{
        path:
          "M448 256c0-106-86-192-192-192V448c106 0 192-86 192-192zM0 256a256 256 0 1 1 512 0A256 256 0 1 1 0 256z",
        css: "fill-yellow-500"
      },
      done: %{
        path:
          "M256 512A256 256 0 1 0 256 0a256 256 0 1 0 0 512zM369 209L241 337c-9.4 9.4-24.6 9.4-33.9 0l-64-64c-9.4-9.4-9.4-24.6 0-33.9s24.6-9.4 33.9 0l47 47L335 175c9.4-9.4 24.6-9.4 33.9 0s9.4 24.6 0 33.9z",
        css: "fill-indigo-500"
      },
      cancelled: %{
        path:
          "M256 512A256 256 0 1 0 256 0a256 256 0 1 0 0 512zM175 175c9.4-9.4 24.6-9.4 33.9 0l47 47 47-47c9.4-9.4 24.6-9.4 33.9 0s9.4 24.6 0 33.9l-47 47 47 47c9.4 9.4 9.4 24.6 0 33.9s-24.6 9.4-33.9 0l-47-47-47 47c-9.4 9.4-24.6 9.4-33.9 0s-9.4-24.6 0-33.9l47-47-47-47c-9.4-9.4-9.4-24.6 0-33.9z",
        css: "fill-gray-400"
      },
      duplicate: %{
        path:
          "M256 512A256 256 0 1 0 256 0a256 256 0 1 0 0 512zM175 175c9.4-9.4 24.6-9.4 33.9 0l47 47 47-47c9.4-9.4 24.6-9.4 33.9 0s9.4 24.6 0 33.9l-47 47 47 47c9.4 9.4 9.4 24.6 0 33.9s-24.6 9.4-33.9 0l-47-47-47 47c-9.4 9.4-24.6 9.4-33.9 0s-9.4-24.6 0-33.9l47-47-47-47c-9.4-9.4-9.4-24.6 0-33.9z",
        css: "fill-gray-400"
      }
    }
  end

  def icon_priority(priority), do: icon_priority_svg()[priority]

  def icon_priority_svg do
    %{
      nopriority: %{
        low: "#444651",
        medium: "#444651",
        high: "#444651"
      },
      low: %{
        low: "currentColor",
        medium: "#444651",
        high: "#444651"
      },
      medium: %{
        low: "currentColor",
        medium: "currentColor",
        high: "#444651"
      },
      high: %{
        low: "currentColor",
        medium: "currentColor",
        high: "currentColor"
      }
    }
  end

  def icon_labels() do
    %{
      "Bug" => "fill-rose-400",
      "Feature" => "fill-purple-400",
      "Improvement" => "fill-blue-400"
    }
  end

  def parse_labels(labels) when is_nil(labels), do: []

  def parse_labels(labels) do
    labels
    |> String.split(", ")
    |> Enum.filter(fn l -> l != "" end)
    |> Enum.map(fn l -> String.trim(l) end)
  end

  def name_of_month(m) do
    month =
      case m do
        1 -> "January"
        2 -> "February"
        3 -> "March"
        4 -> "April"
        5 -> "May"
        6 -> "June"
        7 -> "July"
        8 -> "August"
        9 -> "September"
        10 -> "October"
        11 -> "November"
        12 -> "December"
      end

    String.slice(month, 0..2)
  end

  def issue_top("backlog" = s), do: String.capitalize(s)
  def issue_top(s), do: String.capitalize(s) <> " Issues"
end
