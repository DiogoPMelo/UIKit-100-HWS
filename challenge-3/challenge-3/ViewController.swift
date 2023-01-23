//
//  ViewController.swift
//  challenge-3
//
//  Created by Diogo Melo on 2/23/22.
//

import UIKit

class ViewController: UIViewController {
    var correctWord = "Test"
    var currentGuess = [String]() {
        didSet {
            guessesLabel.text = "\(currentGuess.joined(separator: "")) -> \(correctWord)"
        }
    }
    var guessesLabel: UILabel!
    var inputLetter: UITextField!
    var lifesLabel: UILabel!
    var remainingLifes = 7 {
        didSet {
            lifesLabel.text = "\(remainingLifes) lifes left"
        }
    }
    var missedLettersLabel: UILabel!
    var missedLetters = [String]() {
        didSet {
            missedLettersLabel.text = missedLetters.joined(separator: ", ")
        }
    }
    var allWords = [String]()
    
    override func loadView() {
        view = UIView()
        view.backgroundColor = .black
        
        lifesLabel = UILabel()
        lifesLabel.translatesAutoresizingMaskIntoConstraints = false
        lifesLabel.textAlignment = .right
        lifesLabel.text = "7 lifes left"
//        lifesLabel.backgroundColor = .white
        view.addSubview(lifesLabel)
        
        guessesLabel = UILabel()
        guessesLabel.translatesAutoresizingMaskIntoConstraints = false
        guessesLabel.font = UIFont.systemFont(ofSize: 44)
        guessesLabel.textAlignment = .left
        guessesLabel.text = "TEST"
//        guessesLabel.backgroundColor = .white
        view.addSubview(guessesLabel)
        
        missedLettersLabel = UILabel()
        missedLettersLabel.translatesAutoresizingMaskIntoConstraints = false
        missedLettersLabel.textAlignment = .center
        missedLettersLabel.font = UIFont.systemFont(ofSize: 44)
        missedLettersLabel.text = "T E S"
        missedLettersLabel.layer.borderWidth = 1
        missedLettersLabel.layer.borderColor = UIColor.red.cgColor
//        missedLettersLabel.backgroundColor = .white
        view.addSubview(missedLettersLabel)
        
        inputLetter = UITextField()
        inputLetter.translatesAutoresizingMaskIntoConstraints = false
        inputLetter.placeholder = "Guess a letter"
        inputLetter.textAlignment = .center
        inputLetter.font = UIFont.systemFont(ofSize: 44)
        view.addSubview(inputLetter)
        
        let submit = UIButton(type: .system)
        submit.addTarget(self, action: #selector(submitTapped), for: .touchUpInside)
        submit.translatesAutoresizingMaskIntoConstraints = false
        submit.setTitle("Submit", for: .normal)
        submit.layer.borderWidth = 1
        view.addSubview(submit)
        
        let skip = UIButton(type: .system)
        skip.addTarget(self, action: #selector(randomWord), for: .touchUpInside)
        skip.translatesAutoresizingMaskIntoConstraints = false
        skip.setTitle("Skip", for: .normal)
        skip.layer.borderWidth = 1
        view.addSubview(skip)
        
        NSLayoutConstraint.activate([
            lifesLabel.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor, constant: 20),
            lifesLabel.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor, constant: -20),
            
            skip.topAnchor.constraint(equalTo: lifesLabel.topAnchor),
            skip.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor, constant: 20),
            
            guessesLabel.topAnchor.constraint(equalTo: lifesLabel.bottomAnchor, constant: 20),
            guessesLabel.centerXAnchor.constraint(equalTo: view.layoutMarginsGuide.centerXAnchor),
            
            missedLettersLabel.topAnchor.constraint(equalTo: guessesLabel.bottomAnchor, constant: 20),
            missedLettersLabel.heightAnchor.constraint(equalTo: guessesLabel.heightAnchor, multiplier: 0.8),
            missedLettersLabel.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor, constant: 20),
            
            inputLetter.topAnchor.constraint(equalTo: missedLettersLabel.bottomAnchor, constant: 20),
            inputLetter.centerXAnchor.constraint(equalTo: view.layoutMarginsGuide.centerXAnchor),
            
            submit.topAnchor.constraint(equalTo: inputLetter.bottomAnchor),
            submit.centerXAnchor.constraint(equalTo: view.layoutMarginsGuide.centerXAnchor)
        ])
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        performSelector(inBackground: #selector(loadWords), with: nil)
    }

    @objc func loadWords () {
        if let fileURL = Bundle.main.url(forResource: "words", withExtension: "txt") {
            if let fileContents = try? String.init(contentsOf: fileURL) {
                allWords = fileContents.components(separatedBy: "\n").shuffled()
            }
        }
        
        performSelector(inBackground: #selector(randomWord), with: nil)
    }

    @objc func randomWord () {
        let previousWord = correctWord
        while correctWord == previousWord {
            correctWord = allWords.randomElement()?.uppercased() ?? "PROBLEM"
        }
        
        DispatchQueue.main.async {
            self.currentGuess = Array(repeating: "_", count: self.correctWord.count)
            self.remainingLifes = 7
            self.inputLetter.text = ""
            self.missedLetters = []
            self.missedLettersLabel.text = " "
        }
    }
    
    @objc func submitTapped (_ sender: UIButton) {
        guard let guess = inputLetter.text?.uppercased() else {
            return
        }
        
        guard guess.count == 1 else {
            gameAlert(title: "One letter at a time", message: "Don't type more than one letter")
            return
        }
        
        guard !currentGuess.contains(guess) && !missedLetters.contains(guess) else {
            gameAlert(title: "Letter already used", message: "Try a different letter")
            return
        }
        
        if correctWord.contains(guess) {
        for (index, letter) in correctWord.enumerated() {
            let letterStr = String(letter)
            if guess == letterStr {
                                                 currentGuess[index] = letterStr
                inputLetter.text = ""
            }
        }
        } else {
            missedLetters.append(guess)
            inputLetter.text = ""
            remainingLifes -= 1
        }
        
        if !currentGuess.contains("_") {
            newGameAlert(title: "Congratulations", message: "You guessed the word \(correctWord)!")
            return
        }
        
        if remainingLifes == 0{
            newGameAlert(title: "Game Over", message: "The word was \(correctWord)")
            return
        }
    }
    
    func newGameAlert (title: String, message: String) {
        showAlert(title: title, message: message, button: "Try again") { [weak self] _ in
            self?.randomWord()
        }
    }
    
    func gameAlert (title: String, message: String) {
        showAlert(title: title, message: message, button: "OK") { [weak self] _ in
            self?.inputLetter.text = ""
        }
    }
    
    func showAlert (title: String, message: String, button: String, action: ((UIAlertAction) -> Void)?) {
        let ac = UIAlertController(title: title, message: message, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: button, style: .default) { uaa in
            action?(uaa)
        })
        present(ac, animated: true)
    }
    
}
