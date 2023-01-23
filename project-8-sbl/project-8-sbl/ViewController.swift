//
//  ViewController.swift
//  project-8-sbl
//
//  Created by Diogo Melo on 2/21/22.
//

import UIKit

class ViewController: UIViewController {
    var cluesLabel: UILabel!
    var answersLabel: UILabel!
    var currentAnswer: UITextField!
    var scoreLabel: UILabel!
    var letterButtons = [UIButton]()
    
    var activatedButtons = [UIButton]()
    var solutions = [String]()

    var score = 0 {
        didSet {
            scoreLabel.text = "Score: \(score)"
        }
    }
    var wrongAnswers = 0 {
        didSet {
            if wrongAnswers.isMultiple(of: 7) {
                score -= 1
            }
        }
    }
    var level = 1
    
    override func loadView() {
        view = UIView()
        view.backgroundColor = .black
        
        scoreLabel = UILabel()
        scoreLabel.translatesAutoresizingMaskIntoConstraints = false
        scoreLabel.textAlignment = .right
        scoreLabel.text = "Score: 0"
//        scoreLabel.backgroundColor = .white
        view.addSubview(scoreLabel)
        
        cluesLabel = UILabel()
        cluesLabel.translatesAutoresizingMaskIntoConstraints = false
        cluesLabel.font = UIFont.systemFont(ofSize: 24)
        cluesLabel.text = "CLUES"
        cluesLabel.numberOfLines = 0
        cluesLabel.setContentHuggingPriority(UILayoutPriority(1), for: .vertical)
//        cluesLabel.backgroundColor = .white
        view.addSubview(cluesLabel)
        
        answersLabel = UILabel()
        answersLabel.translatesAutoresizingMaskIntoConstraints = false
        answersLabel.font = UIFont.systemFont(ofSize: 24)
        answersLabel.text = "ANSWERS"
        answersLabel.numberOfLines = 0
        answersLabel.textAlignment = .right
        answersLabel.setContentHuggingPriority(UILayoutPriority(1), for: .vertical)
//        answersLabel.backgroundColor = .yellow
        view.addSubview(answersLabel)
        
        currentAnswer = UITextField()
        currentAnswer.translatesAutoresizingMaskIntoConstraints = false
        currentAnswer.placeholder = "Tap letters to guess"
        currentAnswer.textAlignment = .center
        currentAnswer.font = UIFont.systemFont(ofSize: 44)
        currentAnswer.isUserInteractionEnabled = false
//        currentAnswer.backgroundColor = .green
        view.addSubview(currentAnswer)
        
        let submit = UIButton(type: .system)
        submit.addTarget(self, action: #selector(submitTapped), for: .touchUpInside)
        submit.translatesAutoresizingMaskIntoConstraints = false
        submit.setTitle("Submit", for: .normal)
        submit.layer.borderWidth = 2
        submit.layer.borderColor = UIColor.green.cgColor
//        submit.backgroundColor = .green
        view.addSubview(submit)
        
        let clear = UIButton(type: .system)
        clear.addTarget(self, action: #selector(clearTapped), for: .touchUpInside)
        clear.translatesAutoresizingMaskIntoConstraints = false
        clear.setTitle("CLEAR", for: .normal)
        clear.layer.borderWidth = 2
        clear.layer.borderColor = UIColor.yellow.cgColor
//        clear.backgroundColor = .red
        view.addSubview(clear)
        
        let buttonsView = UIView()
        buttonsView.translatesAutoresizingMaskIntoConstraints = false
//        buttonsView.backgroundColor = .blue
        view.addSubview(buttonsView)
        
        NSLayoutConstraint.activate([
            scoreLabel.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor),
            scoreLabel.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor),
            
            cluesLabel.topAnchor.constraint(equalTo: scoreLabel.bottomAnchor),
            cluesLabel.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor, constant: 100),
            cluesLabel.widthAnchor.constraint(equalTo: view.layoutMarginsGuide.widthAnchor, multiplier: 0.6, constant: -100),
            
            answersLabel.topAnchor.constraint(equalTo: scoreLabel.bottomAnchor),
            answersLabel.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor, constant: -100),
            answersLabel.widthAnchor.constraint(equalTo: view.layoutMarginsGuide.widthAnchor, multiplier: 0.4, constant: -100),
            answersLabel.heightAnchor.constraint(equalTo: cluesLabel.heightAnchor),
            
            currentAnswer.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            currentAnswer.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.5),
            currentAnswer.topAnchor.constraint(equalTo: cluesLabel.bottomAnchor, constant: 20),
            
            submit.topAnchor.constraint(equalTo: currentAnswer.bottomAnchor),
            submit.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: -100),
            submit.heightAnchor.constraint(equalToConstant: 44),
            
            clear.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 100),
            clear.centerYAnchor.constraint(equalTo: submit.centerYAnchor),
            clear.heightAnchor.constraint(equalTo: submit.heightAnchor),
            
            buttonsView.widthAnchor.constraint(equalToConstant: 750),
            buttonsView.heightAnchor.constraint(equalToConstant: 320),
            buttonsView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            buttonsView.topAnchor.constraint(equalTo: submit.bottomAnchor, constant: 20),
            buttonsView.bottomAnchor.constraint(equalTo: view.layoutMarginsGuide.bottomAnchor, constant: -20)
        ])
        
        let width = 150
        let height = 80

        // create 20 buttons as a 4x5 grid
        for row in 0..<4 {
            for col in 0..<5 {
                let letterButton = UIButton(type: .system)
                letterButton.backgroundColor = .white
                letterButton.setTitleColor(.black, for: .normal)
                letterButton.titleLabel?.font = UIFont.systemFont(ofSize: 36)
                letterButton.setTitle("WWW", for: .normal)

                let frame = CGRect(x: col * width, y: row * height, width: width, height: height)
                letterButton.frame = frame

                buttonsView.addSubview(letterButton)
                letterButtons.append(letterButton)
                letterButton.addTarget(self, action: #selector(letterTapped), for: .touchUpInside)
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    performSelector(inBackground: #selector(loadLevel), with: nil)
    }
    
    @objc func loadLevel() {
        var clueString = ""
        var solutionString = ""
        var letterBits = [String]()

        if let levelFileURL = Bundle.main.url(forResource: "level\(level)", withExtension: "txt") {
            if let levelContents = try? String(contentsOf: levelFileURL) {
                var lines = levelContents.components(separatedBy: "\n")
                lines.shuffle()

                for (index, line) in lines.enumerated() {
                    let parts = line.components(separatedBy: ": ")
                    let answer = parts[0]
                    let clue = parts[1]

                    clueString += "\(index + 1). \(clue)\n"

                    let solutionWord = answer.replacingOccurrences(of: "|", with: "")
                    solutionString += "\(solutionWord.count) letters\n"
                    solutions.append(solutionWord)

                    let bits = answer.components(separatedBy: "|")
                    letterBits += bits
                }
            }
        }

        DispatchQueue.main.async {
            self.cluesLabel.text = clueString.trimmingCharacters(in: .whitespacesAndNewlines)
            self.answersLabel.text = solutionString.trimmingCharacters(in: .whitespacesAndNewlines)
        
//        letterBits.shuffle()

            if letterBits.count == self.letterButtons.count {
            for i in 0 ..< self.letterButtons.count {
                self.letterButtons[i].setTitle(letterBits[i], for: .normal)
            }
        }
        }
    }
    
    @objc func letterTapped(_ sender: UIButton) {
        guard let buttonTitle = sender.titleLabel?.text else { return }
        currentAnswer.text = currentAnswer.text?.appending(buttonTitle)
        activatedButtons.append(sender)
        UIView.animate(withDuration: 0.2, delay: 0, options: [], animations: {
            sender.alpha = 0.1
        }) { finished in
            sender.isHidden = true
        }
    }

    @objc func submitTapped(_ sender: UIButton) {
        guard let answerText = currentAnswer.text else { return }

        if let solutionPosition = solutions.firstIndex(of: answerText) {
            activatedButtons.removeAll()
            
                    var splitAnswers = answersLabel.text?.components(separatedBy: "\n")
            splitAnswers?[solutionPosition] = answerText
            answersLabel.text = splitAnswers?.joined(separator: "\n")
            currentAnswer.text = ""

            score += 1

            if answersLabel?.text?.contains("letters") == false {
                let ac = UIAlertController(title: "Well done!", message: "Are you ready for the next level?", preferredStyle: .alert)
                ac.addAction(UIAlertAction(title: "Let's go!", style: .default, handler: levelUp))
                present(ac, animated: true)
            }
        } else {
            wrongAnswers += 1
            let ac = UIAlertController(title: "Wrong", message: "\(answerText) is not a vallid word", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "Try again", style: .default, handler: clearAction))
            present(ac, animated: true)
        }
    }

    @objc func clearTapped(_ sender: UIButton) {
        clearAction()
    }
        
        func clearAction (_ action: UIAlertAction? = nil) {
        currentAnswer.text = ""

            UIView.animate(withDuration: 0.3, delay: 0, options: [], animations: {
                for btn in self.activatedButtons {
            btn.isHidden = false
                    btn.alpha = 1
        }
            }) {finished in
                self.activatedButtons.removeAll()
            }
    }
    
    func levelUp(action: UIAlertAction) {
        level += 1
        solutions.removeAll(keepingCapacity: true)

        performSelector(inBackground: #selector(loadLevel), with: nil)

        for btn in letterButtons {
            btn.isHidden = false
            btn.alpha = 1
        }
    }

}

