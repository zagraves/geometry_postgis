# Στράβων (Strabo)

Postgrex extension for the PostGIS data types. Uses the [geometry](https://github.com/hrzndhrn/geometry) library. 

## Installation

The package can be installed by adding `:strabo` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:strabo, github: "zagraves/strabo"}
  ]
end
```

Make sure PostGIS extension to your database is installed. More information [here](https://trac.osgeo.org/postgis/wiki/UsersWikiPostGIS24UbuntuPGSQL10Apt#Install)

## Examples

Postgrex Extension for the PostGIS data types, Geometry and Geography:

```elixir
Postgrex.Types.define(MyApp.PostgresTypes, [Strabo.Extension], [])

opts = [hostname: "localhost", username: "postgres", database: "strabo_test", types: MyApp.PostgresTypes ]
[hostname: "localhost", username: "postgres", database: "strabo_test", types: MyApp.PostgresTypes]

{:ok, pid} = Postgrex.Connection.start_link(opts)
{:ok, #PID<0.115.0>}

geo = {%Geometry.Point{coordinate: [30, -90]}, 4326}
{%Geometry.Point{coordinate: [30, -90]}, 4326}

{:ok, _} = Postgrex.Connection.query(pid, "CREATE TABLE point_test (id int, geom geometry(Point, 4326))")
{:ok, %Postgrex.Result{columns: nil, command: :create_table, num_rows: 0, rows: nil}}

{:ok, _} = Postgrex.Connection.query(pid, "INSERT INTO point_test VALUES ($1, $2)", [42, geo])
{:ok, %Postgrex.Result{columns: nil, command: :insert, num_rows: 1, rows: nil}}

Postgrex.Connection.query(pid, "SELECT * FROM point_test")
{:ok, %Postgrex.Result{columns: ["id", "geom"], command: :select, num_rows: 1, rows: [{42, {%Geometry.Point{coordinate: [30.0, -90.0]}, 4326}}]}}
```

Use with [Ecto](https://hexdocs.pm/ecto_sql/Ecto.Adapters.Postgres.html#module-extensions):

```elixir
#If using with Ecto, you may want something like thing instead
Postgrex.Types.define(MyApp.PostgresTypes,
              [Strabo.Extension] ++ Ecto.Adapters.Postgres.extensions(),
              json: Jason)

#Add extensions to your repo config
config :thanks, Repo,
  database: "geo_postgrex_test",
  username: "postgres",
  password: "postgres",
  hostname: "localhost",
  adapter: Ecto.Adapters.Postgres,
  types: MyApp.PostgresTypes


#Create a schema
defmodule Test do
  use Ecto.Schema

  schema "test" do
    field :name,           :string
    field :geom,           Strabo.Geometry
  end
end

#Geometry or Geography columns can be created in migrations too
defmodule Repo.Migrations.Init do
  use Ecto.Migration

  def up do
    create table(:test) do
      add :name,     :string
      add :geom,     :geometry
    end
  end

  def down do
    drop table(:test)
  end
end
```

Ecto migrations can also use more elaborate [PostGIS GIS Objects](http://postgis.net/docs/using_postgis_dbmanagement.html#RefObject). These types are useful for enforcing constraints on `{Lng,Lat}` (order matters), or ensuring that a particular projection/coordinate system/format is used.

```elixir
defmodule Repo.Migrations.AdvancedInit do
  use Ecto.Migration

  def up do
    create table(:test) do
      add :name,     :string
    end
    # Add a field `lng_lat_point` with type `geometry(Point,4326)`.
    # This can store a "standard GPS" (epsg4326) coordinate pair {longitude,latitude}.
    execute("SELECT AddGeometryColumn ('test','lng_lat_point',4326,'POINT',2);")

    # Once a GIS data table exceeds a few thousand rows, you will want to build an index to speed up spatial searches of the data
    # Syntax - CREATE INDEX [indexname] ON [tablename] USING GIST ( [geometryfield] );
    execute("CREATE INDEX test_geom_idx ON test USING GIST (lng_lat_point);")
  end

  def down do
    drop table(:test)
  end
end
```

Be sure to enable the PostGIS extension if you haven't already done so:

```elixir
defmodule MyApp.Repo.Migrations.EnablePostgis do
  use Ecto.Migration

  def up do
    execute "CREATE EXTENSION IF NOT EXISTS postgis"
  end

  def down do
    execute "DROP EXTENSION IF EXISTS postgis"
  end
end
```

[PostGIS functions](http://postgis.net/docs/manual-1.3/ch06.html) can also be used in Ecto queries. Currently only the OpenGIS functions are implemented. Have a look at [lib/strabo.ex](lib/strabo.ex) for the implemented functions. You can use them like:

```elixir
defmodule Example do
  import Ecto.Query
  import Strabo

  def example_query(geom) do
    query = from location in Location, limit: 5, select: st_distance(location.geom, ^geom)
    query
    |> Repo.one()
  end
end
```

## Development

After you got the dependencies via `mix deps.get` make sure that:

* `postgis` is installed
* your `postgres` user has the database `"geo_postgrex_test"`
* your `postgres` db user can login without a password or you set the `PGPASSWORD` environment variable appropriately

Then you can run the tests as you are used to with `mix test`.


## Copyright and License

Copyright (c) 2023 Zach Graves
Copyright (c) 2017 Bryan Joseph

Released under the MIT License, which can be found in the repository in [`LICENSE`](https://github.com/zagraves/strabo/blob/master/LICENSE).
