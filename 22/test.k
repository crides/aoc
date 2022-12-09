\l soln.k
r:{."s",($y),".",(`c$"`"+z)," (0:`",x,($y),")"}
run:r@"in"
test:r@"t"
runall:{run.'1++!days,2}

rslts:(66306 195292
 13526 14204
 8233 2821
 477 830
 ("JRVNHHCSJ";"GNFBSBJLH")
 1816 2625
 1427048 2940614
 1733 0
 6018 2619)

days:#rslts
checks:rslts~''(days,2)#runall@()
rpt:{{(d;p):x;"day ",($d)," part ",(`c$"`"+p)}'1++&x}
$[&/&/'checks;"tests passed";rpt@~checks]
