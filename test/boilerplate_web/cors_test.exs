defmodule BoilerplateWeb.CORSTest do
  use ExUnit.Case, async: false

  alias BoilerplateWeb.CORS

  describe "allowed_origins/0" do
    setup do
      old_config = Application.fetch_env!(:boilerplate, BoilerplateWeb.CORS)

      on_exit(fn ->
        Application.put_env(:boilerplate, BoilerplateWeb.CORS, old_config)
      end)
    end

    test "splits origins from config" do
      Application.put_env(:boilerplate, BoilerplateWeb.CORS,
        allowed_origins: "https://app.boilerplate.io,http://localhost:4000"
      )

      allowed_origins = CORS.allowed_origins()
      assert Regex.regex?(allowed_origins)
      assert Regex.match?(allowed_origins, "http://localhost:4000")
      assert allowed_origins == ~r/^(https:\/\/app\.boilerplate\.io)|(http:\/\/localhost:4000)$/
    end

    test "handles single domain" do
      Application.put_env(:boilerplate, BoilerplateWeb.CORS,
        allowed_origins: "http://localhost:4000"
      )

      allowed_origins = CORS.allowed_origins()
      assert Regex.regex?(allowed_origins)
      assert Regex.match?(allowed_origins, "http://localhost:4000")
      assert allowed_origins == ~r/^(http:\/\/localhost:4000)$/
    end

    test "support wildcard subdomains" do
      Application.put_env(:boilerplate, BoilerplateWeb.CORS,
        allowed_origins: "https://app.boilerplate.io,https://*.boilerplate.net"
      )

      allowed_origins = CORS.allowed_origins()

      assert Regex.regex?(allowed_origins)
      assert Regex.match?(allowed_origins, "https://app.boilerplate.io")
      assert Regex.match?(allowed_origins, "https://staging.boilerplate.net")
      assert Regex.match?(allowed_origins, "https://captain-release-20.boilerplate.net")

      assert allowed_origins ==
               ~r/^(https:\/\/app\.boilerplate\.io)|(https:\/\/.+\.boilerplate\.net)$/
    end
  end
end
