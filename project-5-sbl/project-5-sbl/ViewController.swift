//
//  ViewController.swift
//  project-5-sbl
//
//  Created by Diogo Melo on 2/18/22.
//

import UIKit

class ViewController: UITableViewController {
var allWords = [String]()
    var usedWords = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Word")
        
        let skip = UIBarButtonItem(barButtonSystemItem: .fastForward, target: self, action: #selector(startGame))
        skip.accessibilityLabel = "Next word"
        navigationItem.leftBarButtonItem = skip
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(promptForAnswer))
        
        if let startWordsUrl = Bundle.main.url(forResource: "words", withExtension: "txt") {
            if let startWords = try? String.init(contentsOf: startWordsUrl) {
                allWords = startWords.components(separatedBy: "\n")
            }
        }
        
        if allWords.isEmpty {
            allWords = ["silkworm"]
        }
        
        startGame()
    }

    @objc func startGame() {
        title = allWords.randomElement()
        usedWords.removeAll(keepingCapacity: true)
        tableView.reloadData()
    }

    @objc func promptForAnswer () {
        let ac = UIAlertController(title: "Enter answer", message: nil, preferredStyle: .alert)
        
        ac.addTextField()
        let submitAction = UIAlertAction(title: "Submit", style: .default) { [weak self, weak ac] _ in
            guard let answer = ac?.textFields?[0].text else { return }
            self?.submit(answer)
        }
        
        ac.addAction(submitAction)
        present(ac, animated: true)
    }
    
    func submit (_ answer: String) {
        let lowerAnswer = answer.lowercased()
        
        guard lowerAnswer.trimmingCharacters(in: .whitespaces) != title else {
            showAlert(message: "Can't use original word")
            return
        }
        
        guard isPossible(word: lowerAnswer) else {
            showAlert(message: "You can't spell that word from \(title ?? "word")")
            return
        }
        
        guard isOriginal(word: lowerAnswer) else {
            showAlert(message: "Word \(lowerAnswer) already used")
            return
        }
        
        guard isReal(word: lowerAnswer) else {
            showAlert(message: "The word \(lowerAnswer) doesn't exist")
            return
        }
        
            usedWords.insert(lowerAnswer, at: 0)
            
            let indexPath = IndexPath(row: 0, section: 0)
            tableView.insertRows(at: [indexPath], with: .automatic)
            }
    
    func showAlert (message: String) {
        let ac = UIAlertController(title: "Invallid word", message: message, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        present(ac, animated: true)
    }
    
    func isPossible(word: String) -> Bool {
        guard var tempWord = title?.lowercased() else {
            return false
        }
        
        for letter in word {
        if let position = tempWord.firstIndex(of: letter) {
                tempWord.remove(at: position)
            } else {
                return false
            }
        }
        
        return true
    }

    func isOriginal(word: String) -> Bool {
        return !usedWords.contains(word)
    }

    func isReal(word: String) -> Bool {
        guard word.count >= 3 else {
            return false
        }
        
        let checker = UITextChecker()
    let range = NSRange(location: 0, length: word.utf16.count)
    let misspelledRange = checker.rangeOfMisspelledWord(in: word, range: range, startingAt: 0, wrap: false, language: "en")

    return misspelledRange.location == NSNotFound
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        usedWords.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Word", for: indexPath)
        cell.textLabel?.text = usedWords[indexPath.row]
        return cell
    }
}

