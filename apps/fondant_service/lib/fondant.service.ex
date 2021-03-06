defmodule Fondant.Service do
    @moduledoc false

    use Application

    def start(_type, _args) do
        import Supervisor.Spec, warn: false

        children = [
            Fondant.Service.Repo
        ]

        opts = [strategy: :one_for_one, name: Fondant.Service.Supervisor]
        Supervisor.start_link(children, opts)
    end
end
