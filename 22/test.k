\l soln.k
r:{."s",($y),(`c$"`"+z)," (0:`",x,($y),")"}
run:r@"in"
test:r@"t"
runall:{run.'1++!days,2}

rslts:(66306 195292
 13526 14204
 8233 2821
 477 830)

days:#rslts
checks:rslts=(days,2)#runall@
rpt:{{(d;p):x;"day ",($d)," part ",(`c$"`"+p)}'1++&x}
$[&/&/'checks;"tests passed";rpt@~checks]
