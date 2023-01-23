import UIKit

// challenge 1 in project 15

// challenge 2
extension Int {
    func times (_ action: () -> Void) {
        let top = abs(self)
        for _ in 0..<top {
            action()
        }
    }
}

let number = -5
var counter = 0

number.times {
    print("doing stuff")
    counter += 1
}
assert(counter == abs(number), "didn't repeat \(number) times, just \(counter)")

// challenge 3

extension Array where Element: Comparable {
    mutating func remove (_ element: Element) {
        if let index = self.firstIndex(of: element) {
        self.remove(at: index)
        }
    }
}

var numbers = [3, 2, 1, 2, 3, 3]
numbers.remove(3)
numbers.remove(3)
numbers.remove(2)
print(numbers)
