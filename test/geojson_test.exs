defmodule Strabo.GeoJson.Test do
  use ExUnit.Case, async: true

  alias Strabo.GeoJson

  test "it returns expected :xy point dimensionality" do
    feature = %{
      "type" => "Feature",
      "properties" => %{
        "foo" => "bar"
      },
      "geometry" => %{
        "type" => "Point",
        "coordinates" => [47.3913426, -112.2493005]
      }
    }

    assert :xy == GeoJson.get_dimensionality(feature)
  end

  test "it returns expected :xyz point dimensionality" do
    feature = %{
      "type" => "Feature",
      "properties" => %{
        "foo" => "bar"
      },
      "geometry" => %{
        "type" => "Point",
        "coordinates" => [47.3913426, -112.2493005, 497]
      }
    }

    assert :xyz == GeoJson.get_dimensionality(feature)
  end

  test "it returns expected :xyzm point dimensionality" do
    feature = %{
      "type" => "Feature",
      "properties" => %{
        "foo" => "bar"
      },
      "geometry" => %{
        "type" => "Point",
        "coordinates" => [47.3913426, -112.2493005, 497, 1]
      }
    }

    assert :xyzm == GeoJson.get_dimensionality(feature)
  end

  test "it returns expected :xy linestring dimensionality" do
    feature = %{
      "type" => "Feature",
      "properties" => %{
        "foo" => "bar"
      },
      "geometry" => %{
        "type" => "LineString",
        "coordinates" => [
          [-170, 10],
          [170, 11]
        ]
      }
    }

    assert :xy == GeoJson.get_dimensionality(feature)
  end

  test "it returns expected :xyz linestring dimensionality" do
    feature = %{
      "type" => "Feature",
      "properties" => %{
        "foo" => "bar"
      },
      "geometry" => %{
        "type" => "LineString",
        "coordinates" => [
          [-170, 10, 0],
          [170, 11, 0]
        ]
      }
    }

    assert :xyz == GeoJson.get_dimensionality(feature)
  end

  test "it returns expected :xyzm linestring dimensionality" do
    feature = %{
      "type" => "Feature",
      "properties" => %{
        "foo" => "bar"
      },
      "geometry" => %{
        "type" => "LineString",
        "coordinates" => [
          [-170, 10, 0, 0],
          [170, 11, 0, 1]
        ]
      }
    }

    assert :xyzm == GeoJson.get_dimensionality(feature)
  end

  test "it returns expected :xy multilinestring dimensionality" do
    feature = %{
      "type" => "Feature",
      "properties" => %{
        "foo" => "bar"
      },
      "geometry" => %{
        "type" => "MultiLineString",
        "coordinates" => [
          [[170.0, 45.0], [180.0, 45.0]],
          [[-180.0, 45.0], [-170.0, 45.0]]
        ]
      }
    }

    assert :xy == GeoJson.get_dimensionality(feature)
  end

  test "it returns expected :xyz multilinestring dimensionality" do
    feature = %{
      "type" => "Feature",
      "properties" => %{
        "foo" => "bar"
      },
      "geometry" => %{
        "type" => "MultiLineString",
        "coordinates" => [
          [[170.0, 45.0, 1], [180.0, 45.0, 2]],
          [[-180.0, 45.0, 100], [-170.0, 45.0, 101]]
        ]
      }
    }

    assert :xyz == GeoJson.get_dimensionality(feature)
  end

  test "it returns expected :xyzm multilinestring dimensionality" do
    feature = %{
      "type" => "Feature",
      "properties" => %{
        "foo" => "bar"
      },
      "geometry" => %{
        "type" => "MultiLineString",
        "coordinates" => [
          [[170.0, 45.0, 1, 1], [180.0, 45.0, 2, 2]],
          [[-180.0, 45.0, 100, 1], [-170.0, 45.0, 101, 2]]
        ]
      }
    }

    assert :xyzm == GeoJson.get_dimensionality(feature)
  end

  test "it returns expected :xy multipolygon dimensionality" do
    feature = %{
      "type" => "Feature",
      "properties" => %{
        "foo" => "bar"
      },
      "geometry" => %{
        "type" => "MultiPolygon",
        "coordinates" => [
            [
                [
                    [180.0, 40.0], [180.0, 50.0], [170.0, 50.0],
                    [170.0, 40.0], [180.0, 40.0]
                ]
            ],
            [
                [
                    [-170.0, 40.0], [-170.0, 50.0], [-180.0, 50.0],
                    [-180.0, 40.0], [-170.0, 40.0]
                ]
            ]
        ]
      }
    }

    assert :xy == GeoJson.get_dimensionality(feature)
  end

  test "it returns expected :xyz multipolygon dimensionality" do
    feature = %{
      "type" => "Feature",
      "properties" => %{
        "foo" => "bar"
      },
      "geometry" => %{
        "type" => "MultiPolygon",
        "coordinates" => [
            [
                [
                    [180.0, 40.0, 1], [180.0, 50.0, 2], [170.0, 50.0, 3],
                    [170.0, 40.0, 1], [180.0, 40.0, 2]
                ]
            ],
            [
                [
                    [-170.0, 40.0, 3], [-170.0, 50.0, 4], [-180.0, 50.0, 5],
                    [-180.0, 40.0, 3], [-170.0, 40.0, 4]
                ]
            ]
        ]
      }
    }

    assert :xyz == GeoJson.get_dimensionality(feature)
  end

  test "it returns expected :xyzm multipolygon dimensionality" do
    feature = %{
      "type" => "Feature",
      "properties" => %{
        "foo" => "bar"
      },
      "geometry" => %{
        "type" => "MultiPolygon",
        "coordinates" => [
            [
                [
                    [180.0, 40.0, 1, 0], [180.0, 50.0, 2, 0], [170.0, 50.0, 3, 0],
                    [170.0, 40.0, 1, 0], [180.0, 40.0, 2, 0]
                ]
            ],
            [
                [
                    [-170.0, 40.0, 3, 0], [-170.0, 50.0, 4, 1], [-180.0, 50.0, 5, 2],
                    [-180.0, 40.0, 3, 3], [-170.0, 40.0, 4, 4]
                ]
            ]
        ]
      }
    }

    assert :xyzm == GeoJson.get_dimensionality(feature)
  end
end
