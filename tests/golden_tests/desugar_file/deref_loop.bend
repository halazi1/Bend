type nat = (succ pred) | zero

foo = @x match x {
  nat/succ: x.pred
  nat/zero: (bar 0)
}

bar = (foo 1)

main = (foo 0)
