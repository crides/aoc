# vim: set guifont=Uiua386\:h24:
# Experimental!
┌─╴Args
  |Run {Day Part}
  |Test {Day Part}
  |Verify {Day Part}
  |VerifyDay {Day}
  |VerifyAll
  |Input {Day}
└─╴
Usage ↚ (
  ..⊢&args
  $$ Usage: _ ( test | run ) <day> (a | b)
  $$        _ verify [ <day> [ a | b ] ]
  $$        _ input <day>
)
ParseDay  ↚ ⍤$"<day> _ needs to be a number ∊ [1, 25]"⟜(⊸(↧⊃(≥1|≤25))⋕)
ParsePart ↚ ⍤$"<part> _ can only be 'a' or 'b'"⟜⊸(↥∩≍"a","b")
Parse ↚ ⍣(
  ⍤Usage ↧⊃(≥2|≤4)⧻&args
  °□°⊂↘1&args
  ⍣(case(Args~Run⊓(ParseDay|ParsePart)°{⊙∘})°"run"
  | case(Args~Test⊓(ParseDay|ParsePart)°{⊙∘})°"test"
  | case(
      ⨬(Args~VerifyAll°{}
      | Args~VerifyDay ParseDay°□°¤
      | Args~Verify⊓(ParseDay|ParsePart)°{⊙∘}
      )⊸⧻
    )°"verify"
  | case(Args~Input ParseDay°□°¤)°"input"
  | ⍤$"Unknown subcommand: _"⊙0
  )
| 0⍤Usage0&p$"Error: _")
# ? test capture day part
FmtNRun ← (
  ⊃(⊙⋅⊙∘|⋅∘)
  ◌&runi{"uiua" "fmt" "soln.ua"}
  ⊃(⟜$"_~_"$"D_"+8272⊓°⋕⌵◌
  | ⨬(◌|⊙◌)⊸&fe⟜⊂$"__"⨬("in"|"t")
  )
  $$ # Experimental!
  $$ ~ "soln.ua" ~ _
  $$ _ &fras "_"
  :⊂{"uiua" "eval"}□
  ⨬(&runi
  | ⊙⊙◌&runc
    # last char assumed to be '\n'; get last line to get rid of warnings
    ⨬(⍤"Error when running"0&p
    | ⊜⋅∘⊸≠@\n⍜⇌(↘1)
    )=0
  )
)

Solns ← {
  {66306 195292}                  # 1
  {13526 14204}                   # 2
  {8233 2821}                     # 3
  {477 830}                       # 4
  {"JRVNHHCSJ" "GNFBSBJLH"}       # 5
  {1816 2625}                     # 6
  {1427048 2940614}               # 7
  {1733 284648}                   # 8
  {6018 2619}                     # 9
  {14760}                         # 10 "EFGERURE"
  {111210 15447387620}            # 11
  {391 386}                       # 12
  {6187 23520}                    # 13
  {961 26375}                     # 14
  {5832528 13360899249595}        # 15
  {}                              # 16
  {}                              # 17
  {3542 2080}                     # 18
  {5832528 13360899249595}        # 19
  {5962 9862431387256}            # 20
  {104272990112064 3220993874133} # 21
  {20494}                         # 22
  {4218 976}                      # 23
}
# ? day part
CheckSoln ↚ (
  ◡(&p$"checking for day _ part _")
  ◡(°□⬚NaN⊡⊙(°□⬚[]⊡|Solns):⊓(-1|-@a))
  ⨬(⍤$"Day _ part _: Expected: _; got: _"◌◠(◠≍⊓($"_"|FmtNRun 0 1))
  | ⍤:0$"No answer for day _ part _"◌
  )⊸≍NaN
)
Exec ↚ ⍣(
  °Args~Input
  case(
    &fwa⊃(
      $"in_"
    | ⊙("\r\n\r\n"
        ▽⊸≠@\n&fras$"_/.adventofcode.session"&var"HOME"
      )
      $$ GET /2022/day/_/input HTTP/1.0
      $$ Cookie: session=_
      $$ Host: adventofcode.com_
      ⍜&tlsc(&rs∞⊸&w:) "adventofcode.com:443"
      ⍤:≍"200"°□⊏1⊜□⊸≠@ °□⊢⊜□⊸≠@\n ⊙:∩°□°⊟⊜□⊸(¬⦷)"\r\n\r\n".
    ))
| case(◌FmtNRun 0 0)°Args~Run
| case(◌FmtNRun 1 0)°Args~Test
| case(CheckSoln)°Args~Verify
| case(≡CheckSoln⊙"ab")°Args~VerifyDay
| case(⊞CheckSoln+1⇡25"ab")°Args~VerifyAll
)

Exec Parse
