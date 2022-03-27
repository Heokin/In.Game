import UIKit

class A { }

class B {
    weak var a: A!
    
    init(a: A) {
        self.a = a
    }
}

var a: A? = A()

let b = B(a: a!)
//b.a = a

a = nil

print(b.a)
