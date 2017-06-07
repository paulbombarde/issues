defmodule IssuesCliTest do
  use ExUnit.Case

  import Issues.CLI, only: [parse_args: 1, sort_creation_date: 1]

  test "The parser return :help on --help or _h" do
    assert(parse_args(["--help", "blablabla"]) == :help)
    assert(parse_args(["-h", "blablabla"]) == :help)
  end

  test "The parser correctly returns a tuple from the inputs" do
    assert(parse_args(["elixir-lang", "elixir", "9"])=={"elixir-lang", "elixir", 9})
  end

  test "the parser uses the default count value if not specified" do
    assert(parse_args(["elixir-lang", "elixir"])=={"elixir-lang", "elixir", 4})
  end

  test "the sort is really ascending" do
    res = sort_creation_date(created_at_list([3,1,2,5,4]))
    # extract only the created_at part:
    issues = for issue <- res, do: Map.get(issue, "created_at")
    assert issues ==  [1,2,3,4,5]
  end

  defp created_at_list (dates) do
    for value <- dates, do: %{"created_at" => value, "data" => "who cares"}
  end
end
