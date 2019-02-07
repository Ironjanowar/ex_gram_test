defmodule TestBot.Bot do
  @bot :test_bot

  use ExGram.Bot,
    name: @bot

  require Logger

  def bot(), do: @bot

  def handle({:message, %{photo: photos}}, context) do
    [%{file_id: file_id} | _] = Enum.reverse(photos)
    {:ok, %{file_path: file_path}} = ExGram.get_file(file_id)
    token = ExGram.Config.get(:ex_gram, :token)

    {:ok, %{body: body}} = Tesla.get("https://api.telegram.org/file/bot#{token}/#{file_path}")
    File.write("files/test.jpg", body)

    answer(context, "File Downloaded")
  end
end
