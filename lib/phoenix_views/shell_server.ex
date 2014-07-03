defmodule PhoenixViews.ShellServer do
  alias Porcelain.Process, as: Proc

  def start_link(opts \\ []) do
    GenServer.start_link(__MODULE__, :ok, opts)
  end

  def eval(server, command) do
    GenServer.call(server, {:eval, command})
  end

  ## Server callbacks
  def init(:ok) do
    proc = %Proc{pid: pid} = Porcelain.spawn("bash", ["--noediting", "-i"], in: :receive, out: {:send, self()})
    {:ok, proc}
  end

  def handle_call({:eval, command}, _from, proc) do
    Proc.send_input(proc, "#{command}\n")
    {:reply, "fizzbuzz", proc}
  end

  def handle_info({_, :data, data}, proc) do
    Phoenix.Channel.broadcast "shell", "shell", "shell:stdout", %{data: Base.encode64(data)}
    {:noreply, proc}
  end

  def handle_info(noclue, proc) do
    IO.puts "unhandled info"
    IO.inspect noclue
    {:noreply, proc}
  end
end
