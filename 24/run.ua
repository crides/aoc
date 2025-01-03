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
  ....⊢&args
  $$ Usage: _ run <day> (a | b)
  $$        _ test <day> (a | b) [ file ]
  $$        _ submit <day> (a | b) [ answer ]
  $$        _ verify [ <day> [ a | b ] ]
  $$        _ input <day>
)
ParseDay  ↚ ⍤$"<day> _ needs to be a number ∊ [1, 25]"⟜(⊸(↧⊃≥₁≤₂₅)⋕)
ParsePart ↚ ⍤$"<part> _ can only be 'a' or 'b'"⟜⊸(↥∩≍"a","b")
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
  | ⍤$"Unknown subcommand: _"⊙0
  )
| 0⍤Usage0&p$"Error: _")
SoftAssert ← (⨬(&p|◌):)
# out ? test/file capture day part
FmtNRun ← (
  ⊃(⊙⋅⊙∘|⋅∘)
  ◌&runi{"uiua" "fmt" "soln.ua"}
  ⊃(⟜$"_~_"$"D\_\__"⋅⊙⌵
  | ⨬(⨬(◌|⊙◌)⊸&fe⤚⊂$"__"⨬@i@t|∘)⊸type
  )
  $$ ~ "soln.ua" ~ _
  $$ _ &fras "_"
  :⊂{"uiua" "eval" "--experimental"}□
  ⨬(&runi
  | ⊙⊙◌&runc
    # last char assumed to be '\n'; get last line to get rid of warnings
    ⨬(|1 0SoftAssert"Error when running"0&p
    | °□⊣⊜□⊸≠@\n⍜⇌↘₁
    )=0
    ⍥(⍜⇌↘₁↘1)⊸(=@"⊢) # answer is (probably) string, lazily strip quotes
  )
)

Sql ~ "git: github.com/uiua-lang/uiqlite"
Cookie ← (
  Sql~Open $"_/.local/share/qutebrowser/webengine/Cookies" &var"HOME"
  Sql~Prepare "select * from cookies where host_key like '%adventofcode%' and name = 'session';"
  ◇Sql~Close⊣⟜(°□⊡4°¤Sql~QueryValues)
)

# html ? day part ans
Submit ← (
  ◡(&p$"Submitting for day _ part _: _")
  ⊙(Cookie ⊸⧻$"level=_&answer=_" -@`°¤)
  $$ POST /2024/day/_/answer HTTP/1.1
  $$ Accept: */*
  $$ Accept-Encoding: gzip
  $$ Cookie: session=_
  $$ Content-Type: application/x-www-form-urlencoded
  $$ Content-Length: _
  $$ Host: adventofcode.com
  $$ User-Agent: uiua 0.14.0
  $$
  $$ _
  ⍜⊜□(≡⋅"\r\n")×⟜\+⊸=@\n
  ⍜&tlsc(
    °$"_\r\n_"⊸&ru"\r\n\r\n"⊸&w:
    ⍤⋅⊃($"_ _"|≍"200")°$"HTTP/_ _ _"
    ⋕°□₁▽=□"content-length"⊜(∩□¯⌵°$"_: _")¬⊸⦷"\r\n"↘¯4
    ⨬(⋅""|⍜&runs(⊙◌&rs∞&cl⊸&w⤙⊙⊙⊙◌){"gunzip" "-c" "-"}&rb)⊸±
  ) "adventofcode.com:443"
  ⊣°¤regex"(?s)<main>(.*)</main>"
)

Solns ← {{1223326 21070419}
         {686 717}
         {188116424 104245808}
         {2578 1972}
         {4872 5564}
         {5131 1784}
         {1298300076754 248427118972289}
         {361 1249}
         {6385338159127 6415163624282}
         {468 966}
         {213625 252442982856820}
         {1402182 858684}
         {38839 75200131617108}
         {230435667 7709}
         {1349898}
         {85480 518}
         {"1,0,2,0,5,7,2,1,3" 265652340990875}
         {302 "24,32"}
         {324 575227823167869}
         {1338 975376}
         {}
         {17724064040 1998}
         {1075 "az,cg,ei,hz,jc,km,kt,mv,sv,sx,wc,wq,xy"}
         {43559017878162 "fhc,ggt,hqk,mwh,qhj,z06,z11,z35"}
         {2854}}
# ? day part
CheckSoln ↚ (
  ◡(&p$"checking for day _ part _")
  ◡(°□⬚NaN⊡⊙(°□⬚[]⊡|Solns):⊓(-1|-@a))
  ⨬(SoftAssert$"Day _ part _: Expected: _; got: _"◌◠(
      ◠≍⍣⊙⋕∘⊙(FmtNRun 0 1))
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
| ⍩(◌FmtNRun ⍣(1°"")∘⤙⊙⊙⊙◌0)°Args~Test
| ⍩(CheckSoln)°Args~Verify
| ⍩(≡CheckSoln⊙"ab")°Args~VerifyDay
| ⍩(⊞CheckSoln+1⇡25"ab")°Args~VerifyAll
| ⍩(&pCookie)°Args~Cookie
| ⍩(&pSubmit ⊃(⊙∘|⨬(⋅⋅∘|⊙◌FmtNRun0 1)⊃(≍NaN⋅◌|⊙⊙∘)))°Args~Submit
)

Exec Parse
# vim: set guifont=Uiua386\:h24:
