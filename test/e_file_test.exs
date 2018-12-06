defmodule EFileTest do
  use ExUnit.Case
  doctest EFile

  test "greets the world" do
    assert EFile.hello() == :world
  end
end
