import Config

config :boilerplate, BoilerplateWeb.Endpoint,
  http: [port: String.to_integer(System.get_env("BOILERPLATE_PORT")) || 4000],
  debug_errors: true,
  code_reloader: true,
  check_origin: false,
  watchers: []

config :logger, :console, format: "[$level] $message\n"

config :phoenix, :stacktrace_depth, 20

config :phoenix, :plug_init_mode, :runtime
