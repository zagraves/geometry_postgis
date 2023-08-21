defmodule Strabo.GeoJson do
  def decode!(geojson, dim) when is_binary(geojson),
    do: geojson |> Jason.decode!() |> decode!(dim)

  def decode!(geojson, :auto),
    do: geojson |> decode!(get_dimensionality(geojson))

  def decode!(geojson, dim),
    do: geojson |> Geometry.from_geo_json!(dim)

  def get_dimensionality(%{"coordinates" => [_x, _y, _z, _m]}), do: :xyzm
  def get_dimensionality(%{"coordinates" => [_x, _y, _z]}), do: :xyz
  def get_dimensionality(%{"coordinates" => [_x, _y]}), do: :xy
  def get_dimensionality(%{"coordinates" => [[_x, _y, _z, _m] | _]}), do: :xyzm
  def get_dimensionality(%{"coordinates" => [[_x, _y, _z] | _]}), do: :xyz
  def get_dimensionality(%{"coordinates" => [[_x, _y] | _]}), do: :xy
  def get_dimensionality(%{"geometry" => coordinates}), do: get_dimensionality(coordinates)

  def get_dimensionality(_), do: :error
end
