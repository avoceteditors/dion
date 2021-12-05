defmodule Dion.Lexers.Test do
  use ExUnit.Case
  doctest Dion.Lexers

  test "Testing Line Splitter" do
    assert Dion.Lexers.split_line("Test Word Splitter") == ["Test", "Word", "Splitter"]
  end
end
