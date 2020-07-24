defmodule Utils do
  @moduledoc false

  @spec default_opts() :: keyword()
  def default_opts() do
    Application.get_all_env(:vintage_net)
  end

  @spec udhcpc_child_spec(VintageNet.ifname(), String.t()) :: Supervisor.child_spec()
  def udhcpc_child_spec(ifname, hostname) do
    %{
      id: :udhcpc,
      restart: :permanent,
      shutdown: 500,
      start:
        {MuonTrap.Daemon, :start_link,
         [
           "udhcpc",
           [
             "-f",
             "-i",
             ifname,
             "-x",
             "hostname:#{hostname}",
             "-s",
             Application.app_dir(:vintage_net, ["priv", "udhcpc_handler"])
           ],
           [stderr_to_stdout: true, log_output: :debug, log_prefix: "udhcpc(#{ifname}): "]
         ]},
      type: :worker
    }
  end
end

ExUnit.start()
