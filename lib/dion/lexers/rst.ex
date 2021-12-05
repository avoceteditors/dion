defmodule Dion.Lexers.RST do
  @moduledoc """
  Functions used in performing lexical analysis of Dion's implementation
  of reStructuredText (RST).
  """
  @moduledoc since: "0.1.0"


  @doc """
  Function used to perform lexical analysis to identify inline elements.
  """
  @doc since: "0.1.0"
  def lex_inline(text) do
    text
    |> Dion.Lexers.split_line
    |> Stream.map(&Task.async(Dion.Lexers.RST.Inline, :analyze_word, [&1]))
    |> Enum.map(&Task.await(&1))
  end
end
