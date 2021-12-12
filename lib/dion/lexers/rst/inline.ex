defmodule Dion.Lexers.RST.Inline do

  @moduledoc """
  Provides function used to perform lexical analysis, searching for
  inline reStructuredText (RST) elements.
  """
  @moduledoc since: "0.1.0"

  @doc """
  Performs inline lexical analysis on the provided text.

  The `lineno` argument is set on the return elements for reference and
  error reporting purposes.
  """
  def lex(text, lineno) do
    text
    |> String.split(~r/ +/)
    |> Enum.map(
      fn word -> format(word, lineno) end
    )
    |> Stream.map(&Task.async(Dion.Lexers.RST.Inline, :analyze_init, [&1]))
    |> Enum.map(&Task.await(&1))
    |> List.flatten
    |> Stream.map(&Task.async(Dion.Lexers.RST.Inline, :analyze_term, [&1]))
    |> Enum.map(&Task.await(&1))
    |> List.flatten
  end

  @doc """
  Formats the given string, setting line number, type, text, observe and reverse
  enumerated text, text, and raw text.
  """
  @doc since: "0.1.0"
  def format(text, lineno, type) do
    graph = String.graphemes(text)
    data = %{
      lineno: lineno,
      rawtext: text,
      text: text,
      chars: graph,
      rchars: Enum.reverse(graph),
      type: :string
    }
    if type == nil do
      data
    else
      Map.put(data, :type, type)
    end
  end

  def format(text, lineno) do
    format(text, lineno, nil)
  end

  @doc """
  Removes initial characters and reanalyzes the start of the string.
  """
  @doc since: "0.1.0"
  def strip_init(word, chars) do
    format(
      String.slice(word[:text], chars..-1),
      word[:lineno]
    )
    |> analyze_init
  end

  @doc """
  Removes terminal characters and reanalyzes the end of the string.
  """
  @doc since: "0.1.0"
  def strip_term(word, chars) do
    format(
      String.slice(word[:text], 0..chars),
      word[:lineno]
    )
    |> analyze_term
  end

  @doc """
  Performs lexical analysis on the start of the string.
  """
  @doc since: "0.1.0"
  def analyze_init(word) do
    case word[:chars] do
      # Bold
      ["*", "*" | _] -> [:open_bold, strip_init(word, 2)]
      ["*" | _] -> [:open_italic, strip_init(word, 1)]
      ["`", "`" | _] -> [:open_code, strip_init(word, 2)]
      ["`" | _] -> [:open_literal, strip_init(word, 1)]
      ["\"" | _] -> [:open_quote, strip_init(word, 2)]
      [":" | _] -> [:open_colon, strip_init(word, 1)]
      ["_" | _] -> [:open_score, strip_init(word, 1)]
      _ -> [word]
    end
  end

  @doc """
  Evaluates the given word, returns atoms without conideration and passes
  maps on for lexical analysis of the end of the string.
  """
  @doc since: "0.1.0"
  def analyze_term(word) do
    if is_atom(word) do
      word
    else
      analyze_term_content(word)
    end
  end

  @doc """
  Performs lexical analysis on the end of the string.
  """
  @doc since: "0.1.0"
  def analyze_term_content(word) do
    term = Enum.at(word[:rchars], 0)
    cond do
      # Punctation
      term in [".", ",", ";", "'", "?", "-", "]", ")", "}"] ->
        [strip_term(word, -2), format(term, word[:lineno], :punct)]
      true ->
        case word[:rchars] do
          ["*", "*" | _] -> [strip_term(word, -3), :close_bold]
          ["*" | _] -> [strip_term(word, -2), :close_italic]
          ["`", "`" | _] -> [strip_term(word, -3), :close_code]
          ["`" | _] -> [strip_term(word, -2), :close_literal]
          ["\"" | _] -> [strip_term(word, -2), :close_quote]
          [":" | _] -> [strip_term(word, -2), :close_colon]
          ["_" | _] -> [strip_term(word, -2), :close_score]
          _ -> [word]
        end
    end
  end
end
