defmodule Livear.Repo do
  use Ecto.Repo,
    otp_app: :livear,
    adapter: Ecto.Adapters.Postgres
end
