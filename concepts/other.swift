import Foundation

protocol KComparable {
  func better(other: Self) -> Bool
}

extension Int: KComparable {
  func better(other: Int) -> Bool {
    return self > other
  }
}

struct Apple {
  let rating: Int
}

extension Apple: KComparable {
  func better(other: Apple) -> Bool {
    return self.rating > other.rating
  }
}

struct Orange {
  let name: String
}

extension Orange: KComparable {
  func better(other: Orange) -> Bool {
    return self.name > other.name
  }
}

private func run() {
  
  print(42.better(99))
  
  let goodApple = Apple(rating: 5)
  let badApple = Apple(rating: 1)
  print(goodApple.better(badApple))
  
  let navel = Orange(name: "navel")
  let valencia = Orange(name: "valencia")
  navel.better(valencia)
  
  func pick<T: KComparable>(a: T, _ b: T) -> T {
    return a.better(b) ? a : b
  }
  
  print(pick(navel, valencia))
  
  // won't compile because the generic function must be instantiated with the same type for each parameter
  //pick(navel, goodApple)
  
  // won't compile because `KComparable` has Self requirement, so the protocol cannot be used as the type of a value, it may only be used as a generic constraint
  //func pick2(a: KComparable, _ b: KComparable) -> KComparable {
  //  return a.better(b) ? a : b
  //}
  
  // won't compile for the same reason that pick2 above won't compile
  //let foo: KComparable = navel
  
}

