defmodule Dion.Lexers do

  @moduledoc """
  Provides a set of helper functions
  to use in parsing different kinds of text.
  """
  @moduledoc since: "0.1.0"

  ############################ LINE SPLITTER ##############################
  @doc """
  Function executes `Regex.split/2` with a Regular Expression matching
  one or more spaces in the line.

  This function is primarily used in lexical analysis, splitting the line
  on whitespace for parsing inline elements.

  ## Examples

  Simple example of line splitter:

      iex> Dion.Lexers.split_line("I thought the king had more affected the Duke of Albany than Cornwall")
      ["I", "thought", "the", "king", "had", "more", "affected", "the", "Duke", "of", "Albany", "than", "Cornwall"]
  """
  @doc since: "0.1.0"
  def split_line(text) do
    Regex.split(~r/ +/, text)
  end
end
