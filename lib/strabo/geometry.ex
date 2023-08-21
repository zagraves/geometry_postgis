if Code.ensure_loaded?(Ecto.Type) do
  defmodule Strabo.Geometry do
    @moduledoc """
    Implements the Ecto.Type behaviour for all geometry types
    """

    alias Strabo.GeoJson

    alias Geometry.{
      GeometryCollection,
      GeometryCollectionM,
      GeometryCollectionZ,
      GeometryCollectionZM,
      LineString,
      LineStringM,
      LineStringZ,
      LineStringZM,
      MultiLineString,
      MultiLineStringM,
      MultiLineStringZ,
      MultiLineStringZM,
      MultiPoint,
      MultiPointM,
      MultiPointZ,
      MultiPointZM,
      MultiPolygon,
      MultiPolygonM,
      MultiPolygonZ,
      MultiPolygonZM,
      Point,
      PointM,
      PointZ,
      PointZM,
      Polygon,
      PolygonM,
      PolygonZ,
      PolygonZM
    }

    @types [
      "GeometryCollection",
      "Point",
      "LineString",
      "Polygon",
      "MultiPoint",
      "MultiLineString",
      "MultiPolygon"
    ]

    @geometries [
      GeometryCollection,
      GeometryCollectionM,
      GeometryCollectionZ,
      GeometryCollectionZM,
      LineString,
      LineStringM,
      LineStringZ,
      LineStringZM,
      MultiLineString,
      MultiLineStringM,
      MultiLineStringZ,
      MultiLineStringZM,
      MultiPoint,
      MultiPointM,
      MultiPointZ,
      MultiPointZM,
      MultiPolygon,
      MultiPolygonM,
      MultiPolygonZ,
      MultiPolygonZM,
      Point,
      PointM,
      PointZ,
      PointZM,
      Polygon,
      PolygonM,
      PolygonZ,
      PolygonZM
    ]

    if macro_exported?(Ecto.Type, :__using__, 1) do
      use Ecto.Type
    else
      @behaviour Ecto.Type
    end

    def type, do: :geometry

    def blank?(_), do: false

    def load({%struct{} = geom, srid}) when struct in @geometries, do: {:ok, {geom, srid}}
    def load(_), do: :error

    def dump({%struct{} = geom, srid}) when struct in @geometries, do: {:ok, {geom, srid}}
    def dump(_), do: :error

    def cast({:ok, value}), do: cast(value)

    def cast({%struct{} = geom, srid}) when struct in @geometries, do: {:ok, {geom, srid}}

    def cast(%{"type" => "Feature", "geometry" => _} = geojson),
      do: {:ok, {GeoJson.decode!(geojson, :auto), 4326}}

    def cast(%{"type" => type, "coordinates" => _} = geojson) when type in @types,
      do: {:ok, {GeoJson.decode!(geojson, :auto), 4326}}

    def cast(_), do: :error

    def embed_as(_), do: :self
    def equal?(a, b), do: a == b
  end
end
