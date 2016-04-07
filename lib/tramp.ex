defmodule Tramp do
  use Application

  # See http://elixir-lang.org/docs/stable/elixir/Application.html
  # for more information on OTP Applications
  def start(_type, _args) do
    import Supervisor.Spec, warn: false
    Tramp.Supervisor.start_link
    #Supervisor.start_link(children, opts)
  end
end
