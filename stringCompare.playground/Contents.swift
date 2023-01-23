import Foundation

func compare(_ first: String, and second: String) -> Bool {
    return first.compare(second, options: [.diacriticInsensitive, .caseInsensitive]) == .orderedSame
}

let foo = "Ção"
let bar = foo.folding(options: [.diacriticInsensitive, .caseInsensitive], locale: .none)
print(bar) // een
