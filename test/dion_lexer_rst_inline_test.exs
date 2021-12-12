defmodule Dion.Lexers.RST.Inline.Test do
  use ExUnit.Case
  doctest Dion.Lexers.RST.Inline

  test "Inline lexical analysis" do
    data = Enum.at(Dion.Lexers.RST.lex_inline("Example"), 0)
    assert data[:type] == "string"
  end


end
