# server.ex

defmodule Sequence.Server do
    use GenServer

    #####
    # External API

    def start_link(current_number) do
        GenServer.start(__MODULE__, current_number, name: __MODULE__)
    end

    def set_number(new_number) do
        GenServer.call __MODULE__, {:set_number, new_number }
    end

    def next_number do
        GenServer.call __MODULE__, :next_number
    end


    def increment_number(delta) do
        GenServer.cast __MODULE__, {:increment_number, delta }
    end

    #####
    # GenServer implementation

    # multiple handle_call functions with multiple paramaters can be used
    def handle_call(:next_number, _from, current_number) do
        # General API format at least I think: { :reply, response, new staye } 
        { :reply, current_number, current_number+1 }
    end

    def handle_call({:set_number, new_number}, _from, _current_number) do
        { :reply, new_number, new_number }
    end

    def handle_cast({:increment_number, delta}, current_number) do
        { :noreply, current_number + delta }
    end
end

# usage for original version w/o set_number functionality
# - - - - -
# iex -S mix
# iex(1)> { :ok, pid} = GenServer.start_link(Sequence.Server, 100)
# {:ok, #PID<0.148.0>}
# iex(2)> GenServer.call(pid, :next_number)
# 100
# iex(3)> GenServer.call(pid, :next_number)
# 101
# iex(4)> GenServer.call(pid, :next_number)
# 102
# iex(5)> GenServer.call(pid, :next_number)
# 103

# usage with set_number
# - - - - - 
# iex -S mix
# Interactive Elixir (1.5.2) - press Ctrl+C to exit (type h() ENTER for help)
# iex(1)> { :ok, pid } = GenServer.start_link(Sequence.Server, 100)
# {:ok, #PID<0.123.0>}
# iex(2)> GenServer.call(pid, :next_number)
# 100
# iex(3)> GenServer.call(pid, :next_number)
# 101
# iex(4)> GenServer.call(pid, :next_number)
# 102
# iex(5)> GenServer.call(pid, { :set_number, 50})
# 50
# iex(6)> GenServer.call(pid, :next_number)      
# 50
# iex(7)> GenServer.call(pid, :next_number)
# 51
# iex(8)> GenServer.call(pid, :next_number)
# 52

# usage with increment number
# - - - - -
# iex(3)> GenServer.call(pid, :next_number)
# 100
# iex(4)> GenServer.call(pid, :next_number)
# 101
# iex(5)> GenServer.cast(pid, {:increment_number, 49} ) 
# :ok
# iex(6)> GenServer.call(pid, :next_number)            
# 151

# usage with better external API
# - - - - -
# iex(1)> Sequence.Server.start_link 123 
# {:ok, #PID<0.123.0>}
# iex(2)> Sequence.Server.next_number
# 123
# iex(3)> Sequence.Server.next_number
# 124
# iex(4)> Sequence.Server.increment_number 99
# :ok
# iex(5)> Sequence.Server.next_number        
# 224
# iex(6)> Sequence.Server.next_number
# 225

