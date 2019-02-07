defmodule TestBot do
  use Application

  import Supervisor.Spec

  require Logger

  def start(_type, _args) do
    token = ExGram.Config.get(:ex_gram, :token)

    children = [
      supervisor(ExGram, []),
      supervisor(TestBot.Bot, [:polling, token])
    ]

    opts = [strategy: :one_for_one, name: TestBot]

    case Supervisor.start_link(children, opts) do
      {:ok, _} = ok ->
        Logger.info("Starting TestBot")
        ok

      error ->
        Logger.error("Error starting TestBot")
        error
    end
  end
end
