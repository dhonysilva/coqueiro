defmodule Coqueiro.Repo do
  use Ecto.Repo,
    otp_app: :coqueiro,
    adapter: Ecto.Adapters.SQLite3
end
