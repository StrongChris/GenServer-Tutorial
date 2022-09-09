defmodule GsTutTest do
  use ExUnit.Case
  doctest GsTut

  test "greets the world" do
    assert GsTut.hello() == :world
  end
end
