#!/usr/bin/env -S uiua run
# Experimental!
┌─╴Args
  |Run {Day Part}
  |Test {Day Part File}
  |Verify {Day Part}
  |VerifyDay {Day}
  |VerifyAll
  |Input {Day}
  |Cookie
  |Submit {Day Part Answer}
└─╴
Usage ↚ (
  ⊢&args
  ˙$$ Usage: _ run <day> (a | b)
   $$        _ test <day> (a | b) [ file ]
   $$        _ submit <day> (a | b) [ answer ]
   $$        _ verify [ <day> [ a | b ] ]
   $$        _ input <day>
)
ParseDay  ↚ ⍤$"<day> _ needs to be a number ∊ [1, 25]"⟜(⊸(↧⊃≥₁≤₂₅)⋕)
ParsePart ↚ ⍤$"<part> _ can only be 'a' or 'b'"⟜⊸(↥∩⌟≍"a""b")
Parse ↚ ⍣(
  ⍤Usage ↧⊃≥₂≤₅⧻&args
  °□°⊂↘1&args
  ⍣(⍩(Args~Run⊓(ParseDay|ParsePart)°□₂)⍣°"run"°"r"
  | ⍩(Args~Test⊓(⊓(ParseDay|ParsePart)°□₂|°□⬚""⊢)⊃↙↘2)⍣°"test"°"t"
  | ⍩(⨬(Args~VerifyAll°{}
      | Args~VerifyDay ParseDay°□₁
      | Args~Verify⊓(ParseDay|ParsePart)°□₂
      )⊸⧻
    )⍣°"verify"°"v"
  | ⍩(Args~Input ParseDay°□₁)⍣°"input"°"i"
  | ⍩(Args~Cookie°{})⍣°"cookie"°"c"
  | ⍩(Args~Submit⊃(⊓(ParseDay|ParsePart)°□₂↙2|⨬(°□⊣|⋅NaN)⊸(=2⧻)))⍣°"submit"°"s"
  | ˜⍤0$"Unknown subcommand: _"
  )
| 0⍤Usage0&p$"Error: _")
SoftAssert ← ˜⨬(&p|◌)
# out ? test/file capture day part
FmtNRun ← (
  ⊃(⋅∘
  | ⊙⋅⊙∘
    ◌&runi{"uiua" "fmt" "soln.ua"}
    ⊃(⟜$"_~_"$"D,_"⋅⊙⌵
    | ⨬(⨬(◌|⊙◌)⊸&fe⤚⊂$"__"⨬@i@t|∘)⊸type
    )
    $$ ~ "soln.ua" ~ _
    $$ _ &fras "_"
    ⊂{"uiua" "eval" "--experimental"}□
  )
  ⨬(&runi
  | ⊙⋅∘&runc
    # last char assumed to be '\n'; get last line to get rid of warnings
    ⨬(|1 0SoftAssert"Error when running"0&p
    | °□⊣⊜□⊸≠@\n⍜⇌↘₁
    )=0
    ▽⊸(¬⍜⇌\×=@\s)⍥(⍜⇌↘₁↘1)⊸(=@"⊢) # answer is (probably) string, lazily strip quotes
  )
)

Cookie ← (
  ▽⊸≠@\n&fras$"_/.aoc"&var"HOME"
)

# html ? day part ans
Submit ← (
  ◡(&p$"Submitting for day _ part _: _")
  ⊙(Cookie ⊸⧻$"level=_&answer=_" -@`°¤)
  $$ POST /2025/day/_/answer HTTP/1.1
  $$ Accept: */*
  $$ Accept-Encoding: gzip
  $$ Cookie: session=_
  $$ Content-Type: application/x-www-form-urlencoded
  $$ Content-Length: _
  $$ Host: adventofcode.com
  $$ User-Agent: uiua 0.18.0
  $$
  $$ _
  ⍜⊜□(≡⋅"\r\n")×⟜\+⊸=@\n
  ⍜&tlsc(
    °$"_\r\n_"⊸&ru"\r\n\r\n"on˜&w
    ⍤⋅⊃($"_ _"|≍"200")°$"HTTP/_ _ _"
    ⋕°□₁▽=□"content-length"⊜(∩□¯⌵°$"_: _")¬⊸⦷"\r\n"↘¯4
    ⨬(⋅""|°utf₈⌝compress"gzip"&rb)⊸±
  ) "adventofcode.com:443"
  ⊣°¤regex"(?s)<main>(.*)</main>"
)

Solns ← {{}
         }
# ? day part
CheckSoln ↚ (
  ◡(&p$"checking for day _ part _")
  ◡(°□⬚NaN˜⊡°□⬚[]˜⊡Solns⊓(-1|-@a))
  ⨬(SoftAssert$"Day _ part _: Expected: _; got: _"◌◠(
      ◠≍⍣⊙⋕∘⊙(FmtNRun 0 1)
    )
  | ˜SoftAssert0$"No answer for day _ part _"◌
  )⊸≍NaN
)
Exec ↚ ⍣(
  °Args~Input
  ⍩(&fwa⊃(
      $"i_"
    | ⊙(Cookie "\r\n\r\n")
      $$ GET /2025/day/_/input HTTP/1.0
      $$ Cookie: session=_
      $$ Host: adventofcode.com_
      ⍜&tlsc(&rs∞on˜&w) "adventofcode.com:443"
      ⍤⟜(≍"200"°□⊏1⊜□⊸≠@\s°□⊢⊜□⊸≠@\n°□₂⊜□⊸(¬⦷"\r\n\r\n"))
    ))
| ⍩(◌FmtNRun 0 0)°Args~Run
| ⍩(◌FmtNRun ⍣(1°"")∘⤙⊙⊙⊙◌0)°Args~Test
| ⍩(CheckSoln)°Args~Verify
| ⍩(≡CheckSoln⊙"ab")°Args~VerifyDay
| ⍩(⊞CheckSoln+1⇡25"ab")°Args~VerifyAll
| ⍩(&pCookie)°Args~Cookie
| ⍩(&pSubmit ⊃(⊙∘|⨬(⋅⋅∘|⊙◌FmtNRun0 1)⊃(≍NaN⋅◌|⊙⊙∘)))°Args~Submit
)

Exec Parse
# vim: set guifont=Uiua386\:h24:
