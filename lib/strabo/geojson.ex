defmodule Strabo.GeoJson do
  def decode!(geojson, dim) when is_binary(geojson),
    do: geojson |> Jason.decode!() |> decode!(dim)

  def decode!(geojson, :auto),
    do: geojson |> decode!(get_dimensionality(geojson))

  def decode!(_, :error), do: nil

  def decode!(geojson, dim),
    do: geojson |> Geometry.from_geo_json!(dim)

  def get_dimensionality(%{"geometry" => geometry}), do: get_dimensionality(geometry)
  def get_dimensionality(%{"coordinates" => coordinates}), do: get_dimensionality(coordinates)
  def get_dimensionality([head | _tail]) when is_list(head), do: get_dimensionality(head)
  def get_dimensionality([_x, _y, _z, _m]), do: :xyzm
  def get_dimensionality([_x, _y, _z]), do: :xyz
  def get_dimensionality([_x, _y]), do: :xy
  def get_dimensionality(_), do: :error
end
