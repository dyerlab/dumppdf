//: Playground - noun: a place where people can play

import Cocoa

var str = "Hello, playground"


class Foo {
    var bar: String {
        get {
            return self.bar
        }
        set {
            self.bar = newValue
        }
    }
    
    init() {
        self.bar = ""
    }
}


let F = Foo()
print("Foo.bar = \(F.bar)")
print("hello")




