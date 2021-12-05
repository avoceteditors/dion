defmodule Dion.Lexers.RST.Asterisk do
  @moduledoc """
  Provides functions used in lexical analysis of inline elements
  that begin or end with an asterisk.
  """
  @moduledoc since: "0.1.0"


  def clean(word, :bold_italic_code) do
    Regex.replace(~r/^\*\*\*``/, word, "")
  end

  def clean(word, :bold_italic_code_term) do
    Regex.replace(~r/``\*\*\*$/, word, "")
  end

  def clean(word, :bold_code) do
    Regex.replace(~r/\*\*``|``\*\*/, word, "")
  end

  def clean(word, :italic_code) do
    Regex.replace(~r/\*``|``\*/, word, "")
  end

  def clean(word, :bold_italic_term) do
    IO.inspect("TERM")
    Regex.replace(~r/\*\*\*$/, word, "")
  end

  def clean(word, :bold_italic) do
    IO.inspect("YES")
    Regex.replace(~r/\*\*\*/, word, "")
  end

  def clean(word, :bold) do
    Regex.replace(~r/\*\*/, word, "")
  end

  def clean(word, :italic) do
    Regex.replace(~r/\*/, word, "")
  end

  def clean(word, _type) do
    word
  end

  def match_full(word) do
    cond do

      # Match Italic Bold Code
      Regex.match?(~r/^\*\*\*``\S+?``\*\*\*[[:punct:]]?$/, word) ->
        {:full_bold_italic_code, clean(word, :bold_italic_code)}

      # Match Italic Bold
      Regex.match?(~r/^\*\*\*\S+?\*\*\*[[:punct:]]?$/, word) ->
        {:full_bold_italic, clean(word, :bold_italic)}

      # Match Bold Code
      Regex.match?(~r/^\*\*``\S+?``\*\*[[:punct:]]?$/, word) ->
        {:full_bold_code, clean(word, :bold_code)}

      # Match Bold
      Regex.match?(~r/^\*\*\S+?\*\*[[:punct:]]?/, word) ->
        {:full_bold, clean(word, :bold)}

      # Match Italic Code
      Regex.match?(~r/^\*``\S+?``\*[[:punct:]]?$/, word) ->
        {:full_italic_code, clean(word, :italic_code)}

      # Match Italic
      Regex.match?(~r/^\*\S+?\*[[:punct:]]?/, word) ->
        {:full_italic, clean(word, :italic)}

      # Unlikely Zero Match
      true -> {:word, word}
    end
  end

  def match_init(word) do
    cond do
      # Match Italic Bold Code
      Regex.match?(~r/^\*\*\*``\S+?$/, word) ->
        {:init_bold_italic_code, clean(word, :bold_italic_code)}

      # Match Italic Bold
      Regex.match?(~r/^\*\*\*\S+?$/, word) ->
        {:init_bold_italic, clean(word, :bold_italic)}

      # Match Bold Code
      Regex.match?(~r/^\*\*``\S+?$/, word) ->
        {:init_bold_code, clean(word, :bold_code)}

      # Match Bold
      Regex.match?(~r/^\*\*\S+?$/, word) ->
        {:init_bold, clean(word, :bold)}

      # Match Italic Code
      Regex.match?(~r/^\*``\S+?$/, word) ->
        {:init_italic_code, clean(word, :italic_code)}

      # Match Italic
      Regex.match?(~r/^\*\S+?$/, word) ->
        {:init_italic, clean(word, :italic)}

      # Unlikely Zero Match
      true -> {:word, word}
    end
  end

  def match_term(word) do
    cond do
      # Match Italic Bold
      Regex.match?(~r/^\S+?\*\*\*[[:punct:]]*$/, word) ->
        {:term_bold_italic_code, clean(word, :bold_italic_code_term)}

      # Match Italic Bold
      Regex.match?(~r/^\S+?\*\*\*[[:punct:]]*$/, word) ->
        {:term_bold_italic, clean(word, :bold_italic_term)}

      # Match Bold Code
      Regex.match?(~r/^\S+?``\*\*[[:punct:]]*$/, word) ->
        {:term_bold_code, clean(word, :bold_code)}

      # Match Bold
      Regex.match?(~r/^\S+?\*\*[[:punct:]]?$/, word) ->
        {:term_bold, clean(word, :bold)}

      # Match Italic Code
      Regex.match?(~r/^\S+?``\*[[:punct:]]*$/, word) ->
        {:term_italic_code, clean(word, :italic_code)}

      # Match Italic
      Regex.match?(~r/^\S+?\*[[:punct:]]*$/, word) ->
        {:term_italic, clean(word, :italic)}

      # Unlikely Zero Match
      true -> {:word, word}
    end
  end
end
