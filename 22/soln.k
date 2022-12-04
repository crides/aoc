s: {$[y;x+y;0]}\.:' / hacky split and sum
s1a: |/s@
s1b: {s:s@x;m:(*|s),{$[x;0;y]}':s;+/3#m@>m}

s2a: +/{(a;w;b):x-"@ W";b+3 6 0@3!b-a}'
s2b: +/{(a;w;b):x-"A X";1+(3*b)+3!b+a-1}'

p: +/{x-$[x>"a";"`";"&"]}' / priority sum
c: #'=,/?:' / group and count
s3a: p@{g:c(2,-2!#x)#x;*(!g)@&.g=2}'
s3b: {p@{g:c@x;*(!g)@&.g=3}'((-3!#x),3)#x}

p: .'''"-"\''","\'  / parse
i: {(x>z-1)&y<w+1} / contains in
r: {x+!1+y-x} / inclusive range
s4a: +/{i.'(x,y;y,x)}.'p@
s4b: +/~^{(.#'=,/r.'x)?2}'p@
