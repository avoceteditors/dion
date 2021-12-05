defmodule Dion.Lexers.RST.Inline do

  @moduledoc """
  Provides function used to perform lexical analysis, searching for
  inline reStructuredText (RST) elements.
  """
  @moduledoc since: "0.1.0"

  ############### CLEAN IDENTIFIERS ############################################
  def return_value(base, new, word)  do
    if base == :none or base == new do
      {new, word}
    else
      {base, {new, word}}
    end
  end

  ############### ANALYZE WORD BASED ON INIT/TERM VALUES #######################
  @doc """
  Function begins the lexical analysis of an inline reStructuredText (RST)
  element.

  This function uses pattern matching on the initial and terminal characters
  to identify strings that require further analysis with Regular Expressions,
  and which expressions should be used to analyze the word.

  ## Examples

  When `analyze_word_value/3` does not find any matches on a word,
  it returns a tuple with the `:word` atom and the string.

      iex> Dion.Lexers.RST.Inline.analyze_word_value("Word", "W", "d")
      {:word, "Word"}
  """
  @doc since: "0.1.0"

  # Asterisk Match
  def analyze_word_value(word, "*", "*") do
    Dion.Lexers.RST.Asterisk.match_full(word)
  end

  def analyze_word_value(word, "*", _term) do
    Dion.Lexers.RST.Asterisk.match_init(word)
  end

  def analyze_word_value(word, _init, "*") do
    Dion.Lexers.RST.Asterisk.match_term(word)
  end


  # Default Match
  def analyze_word_value(word, _init, _term) do
    {:word, word}
  end

  @doc """
  Function stages lexical analysis for inline reStructuredText (RST)
  elements.

  If the length of the `word` is 1 character or less,
  it returns a tuple with the `:word` atom and thestring.
  If the length is above 1 character, it extracts
  the initial and terminal character, then passes
  the string and these characters to `analyze_word_value/3`
  for deeper analysis.

  ## Examples

  Example of a short word:

      iex> Dion.Lexers.RST.Inline.analyze_word("a")
      {:word, "a"}
  """
  def analyze_word(word) do
    cond do
      String.length(word) in [0, 1]->
        {:word, word}
      true ->
        init = String.at(word, 0)
        term = String.at(word, -1)

        analyze_word_value(word, init, term)
    end
  end

end
