{:ok, _} = Application.ensure_all_started(:ecto_sql)

defmodule Strabo.Test.Helper do
  def opts do
    [
      hostname: "localhost",
      port: 5432,
      username: "postgres",
      database: "postgres",
      password: "postgres",
      types: Strabo.PostgrexTypes
    ]
  end
end

ExUnit.start()
