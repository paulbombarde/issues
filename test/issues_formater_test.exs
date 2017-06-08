defmodule FormaterTest do
  use ExUnit.Case
  import ExUnit.CaptureIO
  import Issues.Formater
  
  setup do
    {:ok, [
      cols: ["very long key", "short", "int", "missing"],
      list: [%{"very long key" => "a", "short" => "abcdef", "int" => 1000, "not used" => "dummy"},
            %{"very long key" => "ab", "short" => "abc", "int" => 100000},
            %{"very long key" => "abc", "short" => "abcdefg", "int" => 1}],
      widths: %{"very long key" => 13, "short" => 7, "int" => 6, "missing" => 7}]}
  end

  test "the width of the column is correctly computed", context do
    assert context[:widths] == compute_widths(context[:cols], context[:list])
  end

  test "the dashed line", ctx do
    assert "+---------------+---------+--------+---------+" == compute_dashed_line(ctx[:cols], ctx[:widths])
  end

  test "a formated line", ctx do
     assert "| a             | abcdef  | 1000   |         |" == compute_line(ctx[:cols], ctx[:widths], hd(ctx[:list]))
  end

  test "full format", ctx do
    expected ="""
    +---------------+---------+--------+---------+
    | very long key | short   | int    | missing |
    +---------------+---------+--------+---------+
    | a             | abcdef  | 1000   |         |
    | ab            | abc     | 100000 |         |
    | abc           | abcdefg | 1      |         |
    +---------------+---------+--------+---------+
    """
    assert expected == capture_io(fn -> format(ctx[:list], ctx[:cols]) end)
  end
end

