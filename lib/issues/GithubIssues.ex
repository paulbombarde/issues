defmodule Issues.GithubIssues do
  @user_agent [{"User-agent", "Elixir"}]
  def fetch(user, project) do
    issues_url(user, project)
    |> HTTPoison.get(@user_agent)
    |> handle_response
  end

  def issues_url(user, project) do
   "http://api.github.com/repos/#{user}/#{project}/issues"
  end

  def handle_response ({:error, reason}) do
    {:error, reason}
  end

  def handle_response ({:ok, %HTTPoison.Response{status_code: 200, body: body}}) do
    body
  end

  def handle_response ({:ok, %HTTPoison.Response{status_code: _, body: body}}) do
    {:error, body} 
  end
end
