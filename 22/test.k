\l soln.k
r:{[typ;num;part;read]."s",($num),".",(`c$"`"+part)," (",($read),":`",typ,($num),")"}
run:r@"in"
test:r@"t"
runall:{run.'+(1+!days,2),,,/+(2;days)#(+tests)[0]}

tests:(0 66306 195292
 0 13526 14204
 0 8233 2821
 0 477 830
 (0;"JRVNHHCSJ";"GNFBSBJLH")
 0 1816 2625
 0 1427048 2940614
 0 1733 0
 0 6018 2619)

days:#tests
rslts:1_'tests
checks:rslts~''(days,2)#runall@()
rpt:{{(d;p):x;"day ",($d)," part ",(`c$"`"+p)}'1++&x}
$[&/&/'checks;"tests passed";rpt@~checks]
