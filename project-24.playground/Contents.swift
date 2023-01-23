import UIKit

let name = "Paul Hudson"

for (index, letter) in name.enumerated() {
    let nextLetter = index < name.count - 1 ?
    "\(name[name.index(name.startIndex, offsetBy: index + 1)])" : ""
//    print(index, "\(letter)\(nextLetter)")
}

print(name.dropFirst(name.components(separatedBy: " ")[0].count))

if name.hasSuffix("son") {
    print(name.dropLast("son".count))
}

extension String {
    var capitalizedFirst: String {
        guard let firstLetter = self.first else { return "" }
        return firstLetter.uppercased() + self.dropFirst()
    }
}

let stupid = "sTuPiD typing SOME peOPle USED"
print(stupid.uppercased(), stupid.lowercased(), stupid.capitalized, stupid.capitalizedFirst, separator: "\n")

let input = "Swift is like Objective-C without the C"
let languages = ["Python", "Ruby", "Swift"]
print(languages.contains(where: input.contains))

// challenges

extension String {
    func addPrefixIfInexistent(_ prefix: String) -> String {
        guard !self.hasPrefix(prefix) else {
            return self
        }
                              return prefix + self
    }
    func isNumeric () -> Bool {
        let numbers = Array(0...9).map({String.init($0)})
        return numbers.contains(where: self.contains)
    }
    
    var lines: [String] {
        self.components(separatedBy: "\n")
    }
}

let pet = "pet"
print(pet.addPrefixIfInexistent("car"))
                              
print("teste".isNumeric(), "teste1".isNumeric())

print("só uma linha".lines, "varias\nlinhas\naqui".lines)

print(Array(name))
