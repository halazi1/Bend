type String = (Nil) | (Cons head ~tail)
type List   = (Nil) | (Cons head ~tail)
type Nat    = (Succ ~pred) | (Zero)

# MAP Impl

type Map = (Node value ~left ~right) | (Leaf)

Map/empty = Map/Leaf

Map/get map key =
  match map {
    Map/Leaf: (*, map)
    Map/Node:
      switch _ = (== 0 key) {
        0: switch _ = (% key 2) {
          0:
            let (got, rest) = (Map/get map.left (/ key 2))
            (got, (Map/Node map.value rest map.right))
          _:
            let (got, rest) = (Map/get map.right (/ key 2))
            (got, (Map/Node map.value map.left rest))
        }
        _: (map.value, map)
      }
  }

Map/set map key value =
  match map {
    Map/Node:
      switch _ = (== 0 key) {
        0: switch _ = (% key 2) {
          0: (Map/Node map.value (Map/set map.left (/ key 2) value) map.right)
          _: (Map/Node map.value map.left (Map/set map.right (/ key 2) value))
        }
        _: (Map/Node value map.left map.right)
      }
    Map/Leaf:
      switch _ = (== 0 key) {
        0: switch _ = (% key 2) {
          0: (Map/Node * (Map/set Map/Leaf (/ key 2) value) Map/Leaf)
          _: (Map/Node * Map/Leaf (Map/set Map/Leaf (/ key 2) value))
        }
        _: (Map/Node value Map/Leaf Map/Leaf)
      }
  }

# IO Impl

type IO:
  Done { magic, expr }
  Call { magic, func, argm, cont }

def IO/MAGIC:
  return (0xD0CA11, 0xFF1FF1)

def IO/wrap(x):
  return IO/Done(IO/MAGIC, x)

def IO/bind(a, b):
  match a:
    case IO/Done:
      return b(a.expr)
    case IO/Call:
      return IO/Call(IO/MAGIC, a.func, a.argm, lambda x: IO/bind(a.cont(x), b))

def call(func, argm):
  return IO/Call(IO/MAGIC, func, argm, lambda x: IO/Done(IO/MAGIC, x))


print text = (IO/Call IO/MAGIC "PUT_TEXT" text @x (IO/Done IO/MAGIC x))
#input = (IO/Call IO/MAGIC "GET_TEXT" * @x (IO/Done IO/MAGIC x))

#read_file path = (IO/Call IO/MAGIC "GET_FILE" path @x (IO/Done IO/MAGIC x))
#write_file path text = (IO/Call IO/MAGIC "PUT_FILE" (path, text) @x (IO/Done IO/MAGIC x))

get_time = (IO/Call IO/MAGIC "GET_TIME" * @x (IO/Done IO/MAGIC x))
sleep hi_lo = (IO/Call IO/MAGIC "PUT_TIME" hi_lo @x (IO/Done IO/MAGIC x))
