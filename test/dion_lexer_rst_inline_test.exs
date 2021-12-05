defmodule Dion.Lexers.RST.Inline.Test do
  use ExUnit.Case
  doctest Dion.Lexers.RST.Inline

  ############################# ASTERISK TESTS #########################

  # Test Italic
  test "Inline Full Italic Match" do
    assert Dion.Lexers.RST.Inline.analyze_word_value("*Word*", "*", "*") == {:full_italic, "Word"}
  end

  test "Inline Initial Italic Match" do
    assert Dion.Lexers.RST.Inline.analyze_word_value("*Word", "*", "d") == {:init_italic, "Word"}
  end

  test "Inline Terminal Italic Match" do
    assert Dion.Lexers.RST.Inline.analyze_word_value("Word*", "W", "*") == {:term_italic, "Word"}
  end

  # Test Italic Code
  test "Inline Full Italic Code Match" do
    assert Dion.Lexers.RST.Inline.analyze_word_value("*``Word``*", "*", "*") == {:full_italic_code, "Word"}
  end
  test "Inline Initial Italic Code Match" do
    assert Dion.Lexers.RST.Inline.analyze_word_value("*``Word", "*", "d") == {:init_italic_code, "Word"}
  end

  test "Inline Terminal Italic Code Match" do
    assert Dion.Lexers.RST.Inline.analyze_word_value("Word``*", "W", "*") == {:term_italic_code, "Word"}
  end

  # Test Bold
  test "Inline Full Bold Match" do
    assert Dion.Lexers.RST.Inline.analyze_word_value("**Word**", "*", "*") == {:full_bold, "Word"}
  end
  test "Inline Initial Bold Match" do
    assert Dion.Lexers.RST.Inline.analyze_word_value("**Word", "*", "d") == {:init_bold, "Word"}
  end
  test "Inline Terminal Bold Match" do
    assert Dion.Lexers.RST.Inline.analyze_word_value("Word**", "W", "*") == {:term_bold, "Word"}
  end

  # Test Bold Code Match
  test "Inline Full Bold Code Match" do
    assert Dion.Lexers.RST.Inline.analyze_word_value("**``Word``**", "*", "*") == {:full_bold_code, "Word"}
  end

  test "Inline Initial Bold Code Match" do
    assert Dion.Lexers.RST.Inline.analyze_word_value("**``Word", "*", "d") == {:init_bold_code, "Word"}
  end

  test "Inline Terminal Bold Code Match" do
    assert Dion.Lexers.RST.Inline.analyze_word_value("Word``**", "W", "*") == {:term_bold_code, "Word"}
  end


  # Test Bold Italic Match
  test "Inline Full Bold Italic Match" do
    assert Dion.Lexers.RST.Inline.analyze_word_value("***Word***", "*", "*") == {:full_bold_italic, "Word"}
  end

  test "Inline Initial Bold Italic Match" do
    assert Dion.Lexers.RST.Inline.analyze_word_value("***Word", "*", "d") == {:init_bold_italic, "Word"}
  end

  test "Inline Terminal Bold Italic Match" do
    assert Dion.Lexers.RST.Inline.analyze_word_value("Word***", "W", "*") == {:term_bold_italic, "Word"}
  end



  test "Inline Full Bold Italic Code Match" do
    assert Dion.Lexers.RST.Inline.analyze_word_value("***``Word``***", "*", "*") == {:full_bold_italic_code, "Word"}
  end




end
