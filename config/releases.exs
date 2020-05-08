import Config

config :boilerplate, BoilerplateWeb.Endpoint,
  url: [host: System.fetch_env!("BOILERPLATE_HOST")],
  http: [
    :inet6,
    port: String.to_integer(System.fetch_env!("BOILERPLATE_PORT")),
    protocol_options: [max_request_line_length: 8192, max_header_value_length: 8192]
  ],
  render_errors: [view: BoilerplateWeb.ErrorView, accepts: ~w(json)],
  secret_key_base: System.fetch_env!("BOILERPLATE_SECRET_KEY_BASE"),
  server: true,
  pubsub: [
    name: Boilerplate.PubSub,
    adapter: Phoenix.PubSub.Redis,
    node_name: System.fetch_env!("HOSTNAME"),
    url: System.fetch_env!("BOILERPLATE_REDIS_PUBSUB_URL")
  ],
  instrumenters: [SpandexPhoenix.Instrumenter]

config :boilerplate, Boilerplate.Repo, url: System.fetch_env!("BOILERPLATE_DATABASE_URL")

config :boilerplate,
  seed_file: System.fetch_env!("BOILERPLATE_ELASTIC_SEED_FILE"),
  ecto_repos: [Boilerplate.Repo],
  redis_cache_url: System.fetch_env!("BOILERPLATE_REDIS_CACHE_URL")

config :boilerplate, Boilerplate.FTStore, adapter: Boilerplate.FTStore.ElasticsearchImpl

config :boilerplate, Boilerplate.FTStore.ElasticsearchImpl,
  url: System.fetch_env!("BOILERPLATE_ELASTIC_URL"),
  default_size: String.to_integer(System.fetch_env!("BOILERPLATE_ELASTIC_DEFAULT_SIZE"))

config :boilerplate, BoilerplateWeb.CORS,
  allowed_origins: System.fetch_env!("BOILERPLATE_ALLOWED_ORIGINS")

config :boilerplate, Boilerplate.Tracer,
  service: String.to_atom(System.fetch_env!("BOILERPLATE_DATADOG_SERVICE_NAME")),
  disabled?: System.fetch_env!("BOILERPLATE_ENABLE_DATADOG") != "true",
  env: System.fetch_env!("BOILERPLATE_DATADOG_ENVIRONMENT_NAME")

config :boilerplate, SpandexDatadog.ApiServer,
  host: System.fetch_env!("BOILERPLATE_DATADOG_HOST"),
  port: String.to_integer(System.fetch_env!("BOILERPLATE_DATADOG_PORT")),
  batch_size: String.to_integer(System.fetch_env!("BOILERPLATE_SPANDEX_BATCH_SIZE")),
  sync_threshold: String.to_integer(System.fetch_env!("BOILERPLATE_SPANDEX_SYNC_THRESHOLD"))

config :boilerplate, TelemetryMetricsStatsd,
  host: System.fetch_env!("BOILERPLATE_DATADOG_HOST"),
  port: String.to_integer(System.fetch_env!("BOILERPLATE_DATADOG_UDP_PORT")),
  formatter: :datadog,
  prefix: System.fetch_env!("BOILERPLATE_DATADOG_SERVICE_NAME")

config :boilerplate, Boilerplate.Users,
  index: System.fetch_env!("BOILERPLATE_USERS_ELASTIC_INDEX"),
  document: System.fetch_env!("BOILERPLATE_USERS_ELASTIC_DOCUMENT")
