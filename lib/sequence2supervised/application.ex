defmodule Sequence2supervised.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  def start(_type, _args) do
    # List all child processes to be supervised
    children = [
      # Starts a worker by calling: Sequence2supervised.Worker.start_link(arg)
      # {Sequence2supervised.Worker, arg},
      # inexplicably this works, and seems to send the proper initial argument
      {Sequence.Server, 123}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Sequence2supervised.Supervisor]
    Supervisor.start_link(children, opts)
  end
end

# Usage, initial version:
# iex -S mix
# iex(1)> Sequence.Server.next_number
# 123
# iex(2)> Sequence.Server.next_number
# 124
# iex(3)> Sequence.Server.increment_number 26
# :ok
# iex(4)> Sequence.Server.increment_number 26
# :ok
# iex(5)> Sequence.Server.next_number        
# 177
# iex(6)> Sequence.Server.set_number 1077
# 1077
# iex(7)> Sequence.Server.next_number    
# 1077
