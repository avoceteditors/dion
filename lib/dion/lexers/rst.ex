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

  def lex_inline(text, lineno) do
    Dion.Lexers.RST.Inline.lex(text, lineno)
  end
  def lex_inline(text) do
    lex_inline(text, 0)
  end




end
