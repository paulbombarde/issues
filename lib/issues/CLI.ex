defmodule Issues.CLI do
  @doc """
  Parses the command line for the issues app
  """
  @default_count 4
  def run(argv) do
    argv
    |> parse_args
    |> process
  end

  def parse_args(argv) do
    case OptionParser.parse(argv, switches: [help: :boolean], aliases: [h: :help]) do
      {[help: true], _         , _} -> :help
      {[], [user, repo, count], []} -> {user, repo, String.to_integer(count)}
      {[], [user, repo]       , []} -> {user, repo, @default_count}
      _ -> :help
    end
  end

  def process(:help) do
    IO.puts """
    Retrieve the N oldest issues from a GitHub repository
    usage : issues <user> <project> [count | #{@default_count}]
    """
    System.halt(0)
  end

  def process({user, project, _count}) do
    Issues.GithubIssues.fetch(user, project)
  end
end
