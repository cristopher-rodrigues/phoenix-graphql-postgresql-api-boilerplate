import Config

config :boilerplate, BoilerplateWeb.Endpoint,
  http: [port: 4000],
  server: false

config :boilerplate,
  redis_cache_url: System.get_env("BOILERPLATE_TEST_REDIS_CACHE_URL")

config :boilerplate, Boilerplate.CacheStore, adapter: Boilerplate.CacheStoreMock

config :boilerplate, Boilerplate.Repo,
  url: System.get_env("BOILERPLATE_TEST_DATABASE_URL"),
  pool: Ecto.Adapters.SQL.Sandbox

config :logger, level: :warn

config :boilerplate, Boilerplate.FTStore.ElasticsearchImpl,
  url: System.get_env("BOILERPLATE_TEST_ELASTIC_URL"),
  default_size: String.to_integer(System.get_env("BOILERPLATE_ELASTIC_DEFAULT_SIZE", "10"))

config :boilerplate, Boilerplate.Users,
  index: System.get_env("BOILERPLATE_TEST_USERS_ELASTIC_INDEX"),
  document: System.get_env("BOILERPLATE_TEST_USERS_ELASTIC_DOCUMENT")

config :boilerplate, Boilerplate.FTStore, adapter: Boilerplate.ElasticMock
