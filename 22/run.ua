# Experimental!
⋊BC&args
Usage ↚ (
  .⊢&args
  $$ Usage: _ <day> (a | b) ( test | run )
  $$        _ <day> input
)
⍤"<day> needs to be a number ∊ [1, 25]"⊸(↧⊃(≥1|≤25))⋕
≍"input",
⟨
  ⍤Usage=4⧻&args
  ⊙⊙(⊢⇌&args)
  ⊙(⊓(⍤Usage ∊□:{"a" "b"}.|⍤Usage <2.⊗:{"run" "test"}))
  ⊃(
    ⊂⊂@D+@`⊙⊙◌
  | ⟨◌|⊙◌⟩&fe.⟜⊂$"__"⊏:{"in" "t"}:⊙:
  )
  .
  $$ # Experimental!
  $$ ~ "soln.ua" ~ _
  $$ _ &fras "_"
  ◌&runi{"uiua" "fmt" "soln.ua"}
  ◌&runi⊂{"uiua" "eval"}□
| ⊙°"input"
  ⍤Usage=3⧻&args
  ⟜$"in_"
  ⊙(
    "\r\n\r\n"
    ⊏⊚⊸≠@\n&fras$"_/.adventofcode.session"&var"HOME"
  )
  $$ GET /2022/day/_/input HTTP/1.0
  $$ Cookie: session=_
  $$ Host: adventofcode.com_
  ⍜&tlsc(&rs∞⊸&w:) "adventofcode.com:443"
  ⍤:≍"200"°□⊏1⊜□⊸≠@ °□⊢⊜□⊸≠@\n ⊙:∩°□°⊟⊜□⊸(¬⦷)"\r\n\r\n".
  &fwa :
⟩
