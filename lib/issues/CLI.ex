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

  @cols ["number", "created_at", "title"]
  def process({user, project, count}) do
    Issues.GithubIssues.fetch(user, project)
    |> decode_response
    |> sort_creation_date
    |> Enum.take(count)
    |> Issues.Formater.format(@cols)
  end

  def decode_response({:ok, body}) do
    body
  end

  def decode_response({:error, error}) do
    {_, message} = List.keyfind(error, "message", 0)
    IO.puts "Error fetching from Github: #{message}"
    System.halt(2)
  end

  def sort_creation_date(issues) do
    Enum.sort(issues, fn i1, i2 -> Map.get(i1, "created_at") <= Map.get(i2, "created_at") end)
  end
end
