main =
  let k = #a{0 1};
  switch k {
    0: 1
    _: (+ k-1 2)
  }
