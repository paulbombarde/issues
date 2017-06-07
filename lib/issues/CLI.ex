defmodule Issues.CLI do
  @doc """
  Parses the command line for the issues app
  """
  @default_count 4
  def run(argv) do
    parse_args(argv)
  end

  def parse_args(argv) do
    case OptionParser.parse(argv, switches: [help: :boolean], aliases: [h: :help]) do
      {[help: true], _         , _} -> :help
      {[], [user, repo, count], []} -> {user, repo, String.to_integer(count)}
      {[], [user, repo]       , []} -> {user, repo, @default_count}
    end
  end
end
