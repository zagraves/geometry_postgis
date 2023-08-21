defmodule Strabo.Test do
  use ExUnit.Case, async: true

  setup do
    {:ok, pid} = Postgrex.start_link(Strabo.Test.Helper.opts())

    {:ok, _result} =
      Postgrex.query(
        pid,
        "DROP TABLE IF EXISTS text_test, point_test, linestring_test, polygon_test, multipoint_test, multilinestring_test, multipolygon_test, geometrycollection_test",
        []
      )

    {:ok, [pid: pid]}
  end

  test "insert point", context do
    pid = context[:pid]
    geom = {%Geometry.Point{coordinate: [30, -90]}, 4326}

    {:ok, _} =
      Postgrex.query(pid, "CREATE TABLE point_test (id int, geom geometry(Point, 4326))", [])

    {:ok, _} = Postgrex.query(pid, "INSERT INTO point_test VALUES ($1, $2)", [42, geom])
    {:ok, result} = Postgrex.query(pid, "SELECT * FROM point_test", [])
    assert(result.rows == [[42, geom]])
  end

  test "insert with text column", context do
    pid = context[:pid]
    geom = {%Geometry.Point{coordinate: [30, -90]}, 4326}

    {:ok, _} =
      Postgrex.query(
        pid,
        "CREATE TABLE text_test (id int, t text, geom geometry(Point, 4326))",
        []
      )

    {:ok, _} =
      Postgrex.query(pid, "INSERT INTO text_test (id, t, geom) VALUES ($1, $2, $3)", [
        42,
        "test",
        geom
      ])

    {:ok, result} = Postgrex.query(pid, "SELECT id, t, geom FROM text_test", [])
    assert(result.rows == [[42, "test", geom]])
  end

  test "insert pointz", context do
    pid = context[:pid]
    geom = {%Geometry.PointZ{coordinate: [30, -90, 70]}, 4326}

    {:ok, _} =
      Postgrex.query(pid, "CREATE TABLE point_test (id int, geom geometry(PointZ, 4326))", [])

    {:ok, _} = Postgrex.query(pid, "INSERT INTO point_test VALUES ($1, $2)", [42, geom])
    {:ok, result} = Postgrex.query(pid, "SELECT * FROM point_test", [])

    assert(result.rows == [[42, geom]])
  end

  test "insert linestring", context do
    pid = context[:pid]
    geom = {%Geometry.LineString{points: [[1, 2], [3, 4]]}, 4326}

    {:ok, _} =
      Postgrex.query(
        pid,
        "CREATE TABLE linestring_test (id int, geom geometry(Linestring, 4326))",
        []
      )

    {:ok, _} = Postgrex.query(pid, "INSERT INTO linestring_test VALUES ($1, $2)", [42, geom])
    {:ok, result} = Postgrex.query(pid, "SELECT * FROM linestring_test", [])

    assert(result.rows == [[42, geom]])
  end

  test "insert polygon", context do
    pid = context[:pid]

    geom = {%Geometry.Polygon{
      rings: [
        [[35, 10], [45, 45], [10, 20], [35, 10]],
        [[20, 30], [35, 35], [30, 20], [20, 30]]
      ]
    }, 4326}

    {:ok, _} =
      Postgrex.query(pid, "CREATE TABLE polygon_test (id int, geom geometry(Polygon, 4326))", [])

    {:ok, _} = Postgrex.query(pid, "INSERT INTO polygon_test VALUES ($1, $2)", [42, geom])
    {:ok, result} = Postgrex.query(pid, "SELECT * FROM polygon_test", [])

    assert(result.rows == [[42, geom]])
  end

  test "insert multipoint", context do
    pid = context[:pid]
    geom = {%Geometry.MultiPoint{points: [[0, 0], [20, 20], [60, 60]]}, 4326}

    {:ok, _} =
      Postgrex.query(
        pid,
        "CREATE TABLE multipoint_test (id int, geom geometry(MultiPoint, 4326))",
        []
      )

    {:ok, _} = Postgrex.query(pid, "INSERT INTO multipoint_test VALUES ($1, $2)", [42, geom])
    {:ok, result} = Postgrex.query(pid, "SELECT * FROM multipoint_test", [])

    assert(result.rows == [[42, geom]])
  end

  test "insert mulitlinestring", context do
    pid = context[:pid]

    geom = {%Geometry.MultiLineString{line_strings: [[[1, 2], [5, 6]]]}, 4326}

    {:ok, _} =
      Postgrex.query(
        pid,
        "CREATE TABLE multilinestring_test (id int, geom geometry(MultiLineString, 4326))",
        []
      )

    {:ok, _} = Postgrex.query(pid, "INSERT INTO multilinestring_test VALUES ($1, $2)", [42, geom])
    {:ok, result} = Postgrex.query(pid, "SELECT * FROM multilinestring_test", [])

    assert(result.rows == [[42, geom]])
  end

  test "insert multipolygon", context do
    pid = context[:pid]

    geom = {%Geometry.MultiPolygon{
      polygons: [
        [
          [
            [11, 12],
            [11, 22],
            [31, 22],
            [11, 12]
          ]
        ]
      ]
    }, 4326}

    {:ok, _} =
      Postgrex.query(
        pid,
        "CREATE TABLE multipolygon_test (id int, geom geometry(MultiPolygon, 4326))",
        []
      )

    {:ok, _} = Postgrex.query(pid, "INSERT INTO multipolygon_test VALUES ($1, $2)", [42, geom])
    {:ok, result} = Postgrex.query(pid, "SELECT * FROM multipolygon_test", [])

    assert(result.rows == [[42, geom]])
  end
end
