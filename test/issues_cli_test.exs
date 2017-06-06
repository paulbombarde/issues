defmodule IssuesCliTest do
  use ExUnit.Case

  import Issues.CLI, only: [parse_args: 1]

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
end
