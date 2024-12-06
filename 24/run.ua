#!/usr/bin/env -S uiua run
# Experimental!
┌─╴Args
  |Run {Day Part}
  |Test {Day Part}
  |Verify {Day Part}
  |VerifyDay {Day}
  |VerifyAll
  |Input {Day}
  |Cookie
└─╴
Usage ↚ (
  ..⊢&args
  $$ Usage: _ ( test | run ) <day> (a | b)
  $$        _ verify [ <day> [ a | b ] ]
  $$        _ input <day>
)
ParseDay   ↚ ⍤$"<day> _ needs to be a number ∊ [1, 25]"⟜(⊸(↧⊃≥₁≤₂₅)⋕)
ParsePart  ↚ ⍤$"<part> _ can only be 'a' or 'b'"⟜⊸(↥∩≍"a","b")
Parse ↚ ⍣(
  ⍤Usage ↧⊃≥₂≤₄⧻&args
  °□°⊂↘1&args
  ⍣(⍩(Args~Run⊓(ParseDay|ParsePart)°□₂)⍣°"run"°"r"
  | ⍩(Args~Test⊓(ParseDay|ParsePart)°□₂)⍣°"test"°"t"
  | ⍩(⨬(Args~VerifyAll°{}
      | Args~VerifyDay ParseDay°□₁
      | Args~Verify⊓(ParseDay|ParsePart)°□₂
      )⊸⧻
    )⍣°"verify"°"v"
  | ⍩(Args~Input ParseDay°□₁)⍣°"input"°"i"
  | ⍩(Args~Cookie°{})⍣°"cookie"°"c"
  | ⍤$"Unknown subcommand: _"⊙0
  )
| 0⍤Usage0&p$"Error: _")
SoftAssert ← (⨬(&p|◌):)
# ? test capture day part
FmtNRun ← (
  ⊃(⊙⋅⊙∘|⋅∘)
  ◌&runi{"uiua" "fmt" "soln.ua"}
  ⊃(⟜$"_~_"$"D_"+8272⊓°⋕⌵◌
  | ⨬(◌|⊙◌)⊸&fe⟜⊂$"__"⨬@i@t
  )
  $$ # Experimental!
  $$ ~ "soln.ua" ~ _
  $$ _ &fras "_"
  :⊂{"uiua" "eval"}□
  ⨬(&runi
  | ⊙⊙◌&runc
    # last char assumed to be '\n'; get last line to get rid of warnings
    ⨬(|1 0SoftAssert"Error when running"0&p
    | °□⊣⊜□⊸≠@\n⍜⇌↘₁
    )=0
  )
)

Sql ~ "git: github.com/uiua-lang/uiqlite"
Cookie ← (
  Sql~Open $"_/.local/share/qutebrowser/webengine/Cookies" &var"HOME"
  Sql~Prepare "select * from cookies where host_key like '%adventofcode%' and name = 'session';"
  ◇Sql~Close⊣⟜(°□⊡4°¤Sql~QueryValues)
)

Solns ← {
  {1223326 21070419}
  {686 717}
  {188116424 104245808}
  {2578 1972}
  {4872 5564}
  {5131 1784}
}
# ? day part
CheckSoln ↚ (
  ◡(&p$"checking for day _ part _")
  ◡(°□⬚NaN⊡⊙(°□⬚[]⊡|Solns):⊓(-1|-@a))
  ⨬(SoftAssert$"Day _ part _: Expected: _; got: _"◌◠(
      ◠≍⍣(
        ⊓°⋕∘
      | ⊙(⍜⇌↘₁↘1) # answer is (probably) string, lazily strip quotes
      )⊙(FmtNRun 0 1))
  | SoftAssert:0$"No answer for day _ part _"◌
  )⊸≍NaN
)
Exec ↚ ⍣(
  °Args~Input
  ⍩(&fwa⊃(
      $"i_"
    | ⊙(Cookie "\r\n\r\n")
      $$ GET /2024/day/_/input HTTP/1.0
      $$ Cookie: session=_
      $$ Host: adventofcode.com_
      ⍜&tlsc(&rs∞⊸&w:) "adventofcode.com:443"
      ⍤:≍"200"°□⊏1⊜□⊸≠@ °□⊢⊜□⊸≠@\n ⊙:°□₂⊜□⊸(¬⦷)"\r\n\r\n".
    ))
| ⍩(◌FmtNRun 0 0)°Args~Run
| ⍩(◌FmtNRun 1 0)°Args~Test
| ⍩(CheckSoln)°Args~Verify
| ⍩(≡CheckSoln⊙"ab")°Args~VerifyDay
| ⍩(⊞CheckSoln+1⇡25"ab")°Args~VerifyAll
| ⍩(&pCookie)°Args~Cookie
)

Exec Parse
# vim: set guifont=Uiua386\:h24:
