defmodule Issues.Formater do
  def format(list, cols) do
    widths = compute_widths(cols, list)
    d = compute_dashed_line(cols, widths)
    IO.puts d
    IO.puts compute_line(cols, widths, Map.new(cols,  &({&1, &1}) ))
    IO.puts d
    Enum.each(list, &(IO.puts compute_line(cols, widths, &1)))
    IO.puts d
  end

  def compute_widths(cols, list) do
    acc = Map.new(cols, &({&1, String.length(&1)}))
    Enum.reduce(list, acc, &(extract_widths(&1,&2)))
  end

  def extract_widths(issue, acc) do
    Map.new(acc, fn({k,v})-> {k, max(v, String.length(to_string(Map.get(issue, k, ""))))} end)
  end

  def compute_dashed_line(cols, widths) do
    # for each colomn, we add a pipe, a blank before the value and a blank after the value
    # then we add a final pipe
    Enum.reduce(cols, "+", fn(k, s) -> s <> String.duplicate("-", Map.get(widths,k)+2) <> "+" end)
  end

  def compute_line(cols, widths, issue) do
    Enum.reduce(cols, "|", fn(k, s) -> s <> " " <> String.pad_trailing(to_string(Map.get(issue, k, "")), Map.get(widths, k)) <> " |" end)
  end

end

