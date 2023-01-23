//
//  ViewController.swift
//  project-2-sbl
//
//  Created by Diogo Melo on 2/14/22.
//

import UIKit

class ViewController: UIViewController {
    var countries = [String]()
    var correctAnswer = 0
    var score = 0.0
    var highestScore = 0.0
    var questionsAnswered = 0
    var isFirstAttempt = true
    let QUESTIONS_LIMIT = 3
    let labels = [
        "estonia": "Flag with three horizontal stripes of equal size. Top stripe blue, middle stripe black, bottom stripe white",
        "france": "Flag with three vertical stripes of equal size. Left stripe blue, middle stripe white, right stripe red",
        "germany": "Flag with three horizontal stripes of equal size. Top stripe black, middle stripe red, bottom stripe gold",
        "ireland": "Flag with three vertical stripes of equal size. Left stripe green, middle stripe white, right stripe orange",
        "italy": "Flag with three vertical stripes of equal size. Left stripe green, middle stripe white, right stripe red",
        "nigeria": "Flag with three vertical stripes of equal size. Left stripe green, middle stripe white, right stripe green",
        "poland": "Flag with two horizontal stripes of equal size. Top stripe white, bottom stripe red",
        "russia": "Flag with three horizontal stripes of equal size. Top stripe white, middle stripe blue, bottom stripe red",
        "spain": "Flag with three horizontal stripes. Top thin stripe red, middle thick stripe gold with a crest on the left, bottom thin stripe red",
        "uk": "Flag with overlapping red and white crosses, both straight and diagonally, on a blue background",
        "us": "Flag with red and white stripes of equal size, with white stars on a blue background in the top-left corner"
    ]
    
    var button1 = UIButton()
    var button2 = UIButton()
    var button3 = UIButton()
    
    let DISTANCE_BETWEEN_BUTTONS: CGFloat = 30
    
    override func viewDidLoad() {
        super.viewDidLoad()
        countries += ["estonia", "france", "germany", "ireland", "italy", "monaco", "nigeria", "poland", "russia", "spain", "uk", "us"]
        
        view.backgroundColor = .gray
        
        let defaults = UserDefaults.standard
        highestScore = defaults.double(forKey: "score")
        
        view.addSubview(button1)
        view.addSubview(button2)
        view.addSubview(button3)
        
        button1.tag = 0
        button2.tag = 1
        button3.tag = 2
        
        button1.addTarget(self,
                              action: #selector(buttonTapped),
                              for: .touchUpInside)
        button2.addTarget(self,
                              action: #selector(buttonTapped),
                              for: .touchUpInside)
        button3.addTarget(self,
                              action: #selector(buttonTapped),
                              for: .touchUpInside)
        
        button1.layer.borderWidth = 1
        button2.layer.borderWidth = 1
        button3.layer.borderWidth = 1
        
        button1.layer.borderColor = UIColor.lightGray.cgColor
        button2.layer.borderColor = UIColor.lightGray.cgColor
        button3.layer.borderColor = UIColor.lightGray.cgColor
        
        button1.translatesAutoresizingMaskIntoConstraints = false
        button2.translatesAutoresizingMaskIntoConstraints = false
        button3.translatesAutoresizingMaskIntoConstraints = false
        
        button1.heightAnchor.constraint(equalTo: view.readableContentGuide.heightAnchor, multiplier: 1/3, constant: -DISTANCE_BETWEEN_BUTTONS).isActive = true
        button1.widthAnchor.constraint(equalTo: button1.heightAnchor, multiplier: 2).isActive = true
        button2.heightAnchor.constraint(equalTo: button1.heightAnchor).isActive = true
        button2.widthAnchor.constraint(equalTo: button1.widthAnchor).isActive = true
        button3.heightAnchor.constraint(equalTo: button2.heightAnchor).isActive = true
        button3.widthAnchor.constraint(equalTo: button1.widthAnchor).isActive = true
        
        button1.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: DISTANCE_BETWEEN_BUTTONS).isActive = true
        button1.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        button2.topAnchor.constraint(equalTo: button1.bottomAnchor, constant: DISTANCE_BETWEEN_BUTTONS).isActive = true
        button2.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        button3.topAnchor.constraint(equalTo: button2.bottomAnchor, constant: DISTANCE_BETWEEN_BUTTONS).isActive = true
        button3.bottomAnchor.constraint(greaterThanOrEqualTo: view.bottomAnchor, constant: -DISTANCE_BETWEEN_BUTTONS).isActive = true
        button3.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        askQuestion()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .pause, target: self, action: #selector(showPoints))
    }

    func askQuestion () {
        countries.shuffle()
        correctAnswer = Int.random(in: 0...2)
        title = countries[correctAnswer].uppercased()
        
        isFirstAttempt = true
        
        button1.setImage(UIImage(named: countries[0]), for: .normal)
        button1.accessibilityLabel = labels[countries[0]]
        button1.isEnabled = true
        button2.setImage(UIImage(named: countries[1]), for: .normal)
        button2.accessibilityLabel = labels[countries[1]]
        button2.isEnabled = true
        button3.setImage(UIImage(named: countries[2]), for: .normal)
        button3.accessibilityLabel = labels[countries[2]]
        button3.isEnabled = true
    }
    
    @objc func showPoints () {
        let ac = UIAlertController(title: "Your current score is \(score) points", message: "Your highest score has been \(highestScore) points so far", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "Back to game", style: .default, handler: { action in }))
        present(ac, animated: true)
    }

    @objc func buttonTapped(_ sender: UIButton) {
        var title: String
        var message: String
        
        let isCorrectAnswer = sender.tag == correctAnswer
        
        if isCorrectAnswer {
            title = "Correct"
            if isFirstAttempt {
            score += 1
                message = "You really know \(countries[sender.tag])"
            } else {
                score += 0.5
                message = "You are starting to know \(countries[sender.tag])"
            }
        } else if isFirstAttempt {
            title = "Hmmmm..."
            message = "Think again, is that really the flag of \(countries[correctAnswer])? That seems more like the flag of \(countries[sender.tag])..."
                    } else {
            score -= 1
            title = "Wrong"
            message = "That's not the flag of \(countries[correctAnswer].uppercased()), that's the flag of \(countries[sender.tag].uppercased().uppercased())"
        }

        let ac = UIAlertController(title: title, message: message, preferredStyle: .alert)
        if isCorrectAnswer || !isFirstAttempt {
            ac.addAction(UIAlertAction(title: "Continue", style: .default, handler: askQuestionOrFinish))
        } else {
            dimWrongFlag(at: sender.tag)
            ac.addAction(UIAlertAction(title: "Try again", style: .default, handler: secondChance))
        }
        present(ac, animated: true)
    }
        
    func askQuestionOrFinish (action: UIAlertAction? = nil) {
        questionsAnswered += 1
        if questionsAnswered.isMultiple(of: QUESTIONS_LIMIT) {
            let title: String
            if  score <= 0{
                title = "GAME OVER"
            } else if score > highestScore {
                title = "Congratulations! You set a new record"
                DispatchQueue.global(qos: .background).async {
                    let defaults = UserDefaults.standard
                    self.highestScore = self.score
                    defaults.set(self.highestScore, forKey: "score")
                }
                
            } else {
                title = "Congratulations!"
            }
            let ac = UIAlertController(title: title, message: "Your final score is \(score)", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "Restart", style: .default, handler: finishGame))
        present(ac, animated: true)
        } else {
            askQuestion()
        }
    }
    
    func dimWrongFlag (at index: Int) {
        if index == 0 {
            button1.isEnabled = false
        } else if index == 1 {
            button2.isEnabled = false
        } else if index == 2 {
            button3.isEnabled = false
                }
    }
    
    func secondChance (action: UIAlertAction? = nil) {
        isFirstAttempt = false
    }
    
    func finishGame (action: UIAlertAction? = nil) {
        score = 0
        questionsAnswered = 0
        askQuestion()
    }
}

