defmodule Strabo.Extension do
  @moduledoc """
  PostGIS extension for Postgrex. Supports Geometry and Geography data types.

  ## Examples

  Create a new Postgrex Types module:

      Postgrex.Types.define(MyApp.PostgresTypes, [Strabo.Extension], [])

  If using with Ecto, you may want something like thing instead:

      Postgrex.Types.define(MyApp.PostgresTypes,
                    [Strabo.Extension] ++ Ecto.Adapters.Postgres.extensions(),
                    json: Jason)

      opts = [hostname: "localhost", username: "postgres", database: "strabo_test",
      types: MyApp.PostgresTypes ]

      [hostname: "localhost", username: "postgres", database: "strabo_test",
        types: MyApp.PostgresTypes]

      {:ok, pid} = Postgrex.Connection.start_link(opts)
      {:ok, #PID<0.115.0>}

      geo = {%Geometry.Point{coordinate: {30, -90}, 4326}
      {%Geometry.Point{coordinate: {30, -90}, 4326}

      {:ok, _} = Postgrex.Connection.query(pid, "CREATE TABLE point_test (id int, geom geometry(Point, 4326))")
      {:ok, %Postgrex.Result{columns: nil, command: :create_table, num_rows: 0, rows: nil}}

      {:ok, _} = Postgrex.Connection.query(pid, "INSERT INTO point_test VALUES ($1, $2)", [42, geo])
      {:ok, %Postgrex.Result{columns: nil, command: :insert, num_rows: 1, rows: nil}}

      Postgrex.Connection.query(pid, "SELECT * FROM point_test")
      {:ok, %Postgrex.Result{columns: ["id", "geom"], command: :select, num_rows: 1,
      rows: [{42, {%Geometry.Point{coordinate: {30, -90}, 4326}}]

  """

  @behaviour Postgrex.Extension

  @types [
    Geometry.Feature,
    Geometry.FeatureCollection,
    Geometry.GeometryCollection,
    Geometry.GeometryCollectionM,
    Geometry.GeometryCollectionZ,
    Geometry.GeometryCollectionZM,
    Geometry.LineString,
    Geometry.LineStringM,
    Geometry.LineStringZ,
    Geometry.LineStringZM,
    Geometry.MultiLineString,
    Geometry.MultiLineStringM,
    Geometry.MultiLineStringZ,
    Geometry.MultiLineStringZM,
    Geometry.MultiPoint,
    Geometry.MultiPointM,
    Geometry.MultiPointZ,
    Geometry.MultiPointZM,
    Geometry.MultiPolygon,
    Geometry.MultiPolygonM,
    Geometry.MultiPolygonZ,
    Geometry.MultiPolygonZM,
    Geometry.Point,
    Geometry.PointM,
    Geometry.PointZ,
    Geometry.PointZM,
    Geometry.Polygon,
    Geometry.PolygonM,
    Geometry.PolygonZ,
    Geometry.PolygonZM,
  ]

  def init(opts) do
    Keyword.get(opts, :decode_copy, :copy)
  end

  def matching(_) do
    [type: "geometry", type: "geography"]
  end

  def format(_) do
    :binary
  end

  def encode(_opts) do
    quote location: :keep do
      {%x{} = geom, srid} when x in unquote(@types) ->
        data = Geometry.to_ewkb(geom, srid, :xdr)
        [<<IO.iodata_length(data)::integer-size(32)>> | data]
    end
  end

  def decode(:reference) do
    quote location: :keep do
      <<len::integer-size(32), wkb::binary-size(len)>> ->
        Geometry.from_ewkb!(wkb)
    end
  end

  def decode(:copy) do
    quote location: :keep do
      <<len::integer-size(32), wkb::binary-size(len)>> ->
        Geometry.from_ewkb!(:binary.copy(wkb))
    end
  end
end
