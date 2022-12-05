\d s1
s: {$[y;x+y;0]}\.:' / hacky split and sum
a: |/s@
b: {s:s@x;m:(*|s),{$[x;0;y]}':s;+/3#m@>m}

\d s2
a: +/{(a;w;b):x-"@ W";b+3 6 0@3!b-a}'
b: +/{(a;w;b):x-"A X";1+(3*b)+3!b+a-1}'

\d s3
p: +/{x-$[x>"a";"`";"&"]}' / priority sum
c: #'=,/?:' / group and count
a: p@{g:c(2,-2!#x)#x;*(!g)@&.g=2}'
b: {p@{g:c@x;*(!g)@&.g=3}'((-3!#x),3)#x}

\d s4
p: .'''"-"\''","\'  / parse
i: {(x>z-1)&y<w+1} / contains in
r: {x+!1+y-x} / inclusive range
a: +/{i.'(x,y;y,x)}.'p@
b: +/~^{(.#'=,/r.'x)?2}'p@

\d s5
p: {i:1+4*!-4!1+#*x;s:((d:*&""~/:x)-1)#x;((~" "=)#'+s@\:i;{.'(" "\x)@1 3 5}'(1+d)_x)}
a: {(s;i):p@x;*'s{(n;a;b):y;d:|n#x@a-1;@[@[x;a-1;n_];b-1;d,]}/i}
b: {(s;i):p@x;*'s{(n;a;b):y;d:n#x@a-1;@[@[x;a-1;n_];b-1;d,]}/i}

\d .
