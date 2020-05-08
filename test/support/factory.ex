defmodule Boilerplate.Factory do
  use ExMachina.Ecto, repo: Boilerplate.Repo
  alias Boilerplate.Users.User

  def user_factory do
    %User{
      uuid: Faker.UUID.v4(),
      name: Faker.Superhero.name()
    }
  end
end
