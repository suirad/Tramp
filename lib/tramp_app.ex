defmodule Tramp.Application do
  use GenServer
  use AMQP

  def start_link do
    GenServer.start_link(__MODULE__, [], [])
  end

  @exchange     "mc.Tramp"
  @queue        "mc.Tramp"

  def init(_opts) do
    {:ok, conn} = Connection.open(username: "bukkit", password: "bukkit")
    {:ok, chan} = Channel.open(conn)
    Basic.qos(chan, [prefetch_count: 10])
    Queue.declare(chan, @queue, [durable: true])
    #Exchange.fanout(chan, @exchange, [durable: false])
    Queue.bind(chan, @queue, "mc.debug")

    {:ok, _consumer_tag} = Basic.consume(chan, @queue)
    {:ok, chan}
  end

  def handle_info({:basic_consume_ok, _meta}, chan) do
    {:noreply, chan}
  end

  def handle_info({:basic_cancel, _meta}, chan) do
    {:noreply, chan}
  end

  def handle_info({:basic_cancel_ok, _meta}, chan) do
    {:noreply, chan}
  end

  def handle_info({:basic_deliver, payload, %{delivery_tag: tag}}, chan) do
    IO.puts "Received: #{payload}"
    Basic.ack(chan, tag)
    {:noreply, chan}
  end

end
