defmodule Issues.Formater do
  def format(list, cols) do
    widths = compute_widths(list, cols)
    d = compute_dashed_line(widths)
    IO.puts d
    IO.puts compute_line(widths, Map.new(cols,  &({&1, &1}) ))
    IO.puts d
    Enum.each(list, &(IO.puts compute_line(widths, &1)))
    IO.puts d
  end

  def compute_widths(list, cols) do
    acc = Map.new(cols, &({&1, String.length(&1)}))
    Enum.reduce(list, acc, &(extract_widths(&1,&2)))
  end

  def extract_widths(issue, acc) do
    Map.new(acc, fn({k,v})-> {k, max(v, String.length(to_string(Map.get(issue, k, ""))))} end)
  end

  def compute_dashed_line(widths) do
    # for each colomn, we add a pipe, a blank before the value and a blank after the value
    # then we add a final pipe
    Enum.reduce(widths, "+", fn({_k,v}, s) -> s <> String.duplicate("-", v+2) <> "+" end)
  end

  def compute_line(widths, issue) do
    Enum.reduce(widths, "|", fn({k,v}, s) -> s <> " " <> String.pad_trailing(to_string(Map.get(issue, k, "")), v) <> " |" end)
  end

end

