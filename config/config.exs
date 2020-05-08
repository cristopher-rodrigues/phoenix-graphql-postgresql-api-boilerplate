import Config

Code.eval_file("./config/dotenv.exs")

config :boilerplate, BoilerplateWeb.Endpoint,
  url: [host: System.get_env("BOILERPLATE_HOST", "localhost")],
  secret_key_base: System.get_env("BOILERPLATE_SECRET_KEY_BASE"),
  render_errors: [view: BoilerplateWeb.ErrorView, accepts: ~w(json)],
  pubsub: [
    name: Boilerplate.PubSub,
    adapter: Phoenix.PubSub.Redis,
    node_name: System.get_env("HOSTNAME"),
    url: System.get_env("BOILERPLATE_REDIS_PUBSUB_URL")
  ],
  instrumenters: [SpandexPhoenix.Instrumenter]

config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

config :phoenix, :json_library, Jason

config :elastix, json_codec: Jason

config :boilerplate, Boilerplate.Repo, url: System.get_env("BOILERPLATE_DATABASE_URL")

config :boilerplate,
  env: Mix.env(),
  seed_file: System.get_env("BOILERPLATE_ELASTIC_SEED_FILE"),
  ecto_repos: [Boilerplate.Repo],
  redis_cache_url: System.get_env("BOILERPLATE_REDIS_CACHE_URL")

config :boilerplate, Boilerplate.FTStore, adapter: Boilerplate.FTStore.ElasticsearchImpl

config :boilerplate, Boilerplate.FTStore.ElasticsearchImpl,
  url: System.get_env("BOILERPLATE_ELASTIC_URL"),
  default_size: String.to_integer(System.get_env("BOILERPLATE_ELASTIC_DEFAULT_SIZE", "10"))

config :boilerplate, BoilerplateWeb.CORS,
  allowed_origins: System.get_env("BOILERPLATE_ALLOWED_ORIGINS")

config :spandex_ecto, SpandexEcto.EctoLogger,
  tracer: Boilerplate.Tracer,
  service: :boilerplate_ecto

config :boilerplate, Boilerplate.CacheStore, adapter: Boilerplate.CacheStore.RedisImpl

config :boilerplate, Boilerplate.Tracer,
  service: String.to_atom(System.get_env("BOILERPLATE_DATADOG_SERVICE_NAME", "boilerplate")),
  adapter: SpandexDatadog.Adapter,
  disabled?: System.get_env("BOILERPLATE_ENABLE_DATADOG") != "true",
  env: System.get_env("BOILERPLATE_DATADOG_ENVIRONMENT_NAME", "development")

config :spandex_phoenix, tracer: Boilerplate.Tracer

config :boilerplate, SpandexDatadog.ApiServer,
  host: System.get_env("BOILERPLATE_DATADOG_HOST", "localhost"),
  port: String.to_integer(System.get_env("BOILERPLATE_DATADOG_PORT", "8126")),
  batch_size: String.to_integer(System.get_env("BOILERPLATE_SPANDEX_BATCH_SIZE", "10")),
  sync_threshold: String.to_integer(System.get_env("BOILERPLATE_SPANDEX_SYNC_THRESHOLD", "100")),
  http: HTTPoison

config :boilerplate, TelemetryMetricsStatsd,
  host: System.get_env("BOILERPLATE_DATADOG_HOST", "localhost"),
  port: String.to_integer(System.get_env("BOILERPLATE_DATADOG_UDP_PORT", "8125")),
  formatter: :datadog,
  prefix: System.get_env("BOILERPLATE_DATADOG_SERVICE_NAME", "boilerplate")

config :boilerplate, Boilerplate.Users,
  index: System.get_env("BOILERPLATE_USERS_ELASTIC_INDEX"),
  document: System.get_env("BOILERPLATE_USERS_ELASTIC_DOCUMENT")

import_config "#{Mix.env()}.exs"
