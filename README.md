# Dion

Dion provides a lexer, parser, and standard 
for the Dion language, 
which is a superset and extension 
of reStructuredText (RST)
from the Docutils library.

Its name is a contraction of Διονυσος, intending to evoke
the Kunsttriebe as described by Nietzsche.  That is, using
a simple markup language to reduce the role of Απολλων in
the productive use of language.


## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed
by adding `dion` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:dion, "~> 0.1.0"}
  ]
end
```

Documentation can be generated with [ExDoc](https://github.com/elixir-lang/ex_doc)
and published on [HexDocs](https://hexdocs.pm). Once published, the docs can
be found at [https://hexdocs.pm/dion](https://hexdocs.pm/dion).

## Milestones

* **Inline Lexical Analysis** - v.0.1.x (*In-Progress*)

  Work on this feature will occur in `Dion.Lexers.RST` and will
  cover the lexical analysis of strings.  The goal is to identify
  markup for elements that occur within a block.

  | Version | Target |
  |---|---|
  | 0.1.0 | Punctual markup, such as bold, italics, bolded italics, inline code, literal, and quotes. |

  



