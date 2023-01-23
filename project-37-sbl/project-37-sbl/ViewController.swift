//
//  ViewController.swift
//  project-37-sbl
//
//  Created by Diogo Melo on 4/27/22.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {

    var allCards = [CardViewController]()
    var cardContainer: UIView!
    
    var music: AVAudioPlayer!
    
    
    override func loadView() {
        super.loadView()
        
        cardContainer = UIView()
        cardContainer.backgroundColor = .clear
        cardContainer.autoresizesSubviews = false
        view.addSubview(cardContainer)
        cardContainer.translatesAutoresizingMaskIntoConstraints = false
        
        
        NSLayoutConstraint.activate([
            cardContainer.heightAnchor.constraint(equalToConstant: 320),
            cardContainer.widthAnchor.constraint(equalToConstant: 480),
            cardContainer.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            cardContainer.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadCards()
//        playMusic()
    }
    
    @objc func loadCards() {
        for card in allCards {
            card.view.removeFromSuperview()
            card.removeFromParent()
        }

        allCards.removeAll(keepingCapacity: true)
        
        // create an array of card positions
        let positions = [
            CGPoint(x: 75, y: 85),
            CGPoint(x: 185, y: 85),
            CGPoint(x: 295, y: 85),
            CGPoint(x: 405, y: 85),
            CGPoint(x: 75, y: 235),
            CGPoint(x: 185, y: 235),
            CGPoint(x: 295, y: 235),
            CGPoint(x: 405, y: 235)
        ]

        // load and unwrap our Zener card images
        let circle = (image: UIImage(named: "cardCircle")!, label: "Circle")
        let cross = (image: UIImage(named: "cardCross")!, label: "Cross")
        let lines = (image: UIImage(named: "cardLines")!, label: "Lines")
        let square = (image: UIImage(named: "cardSquare")!, label: "Square")
        let star = (image: UIImage(named: "cardStar")!, label: "Star")

        // create an array of the images, one for each card, then shuffle it
        var images = [circle, circle, cross, cross, lines, lines, square, star]
        images.shuffle()

        for (index, position) in positions.enumerated() {
            // loop over each card position and create a new card view controller
            let card = CardViewController()
            card.delegate = self
            card.setAccessibilityLabel(position: "Card \(index + 1)", label: images[index].label)

            // use view controller containment and also add the card's view to our cardContainer view
            addChild(card)
            cardContainer.addSubview(card.view)
            card.didMove(toParent: self)

            // position the card appropriately, then give it an image from our array
            card.view.center = position
            card.front.image = images[index].image

            // if we just gave the new card the star image, mark this as the correct answer
            if card.front.image == star.image {
                card.isCorrect = true
            }

            // add the new card view controller to our array for easier tracking
            allCards.append(card)
        }
        
        view.isUserInteractionEnabled = true
    }
    
    func cardTapped(_ tapped: CardViewController) {
        guard view.isUserInteractionEnabled == true else { return }
        view.isUserInteractionEnabled = false

        for card in allCards {
            if card == tapped {
                card.wasTapped()
                card.perform(#selector(card.wasntTapped), with: nil, afterDelay: 1)
            } else {
                card.wasntTapped()
            }
        }

        perform(#selector(loadCards), with: nil, afterDelay: 2)
    }

    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesMoved(touches, with: event)

        guard let touch = touches.first else { return }
        let location = touch.location(in: cardContainer)

        for card in allCards {
            if card.view.frame.contains(location) {
                if view.traitCollection.forceTouchCapability == .available {
                    if touch.force == touch.maximumPossibleForce {
                        card.front.image = UIImage(named: "cardStar")
                        card.isCorrect = true
                    }
                }
            }
        }
    }
    
    func playMusic() {
        if let musicURL = Bundle.main.url(forResource: "PhantomFromSpace", withExtension: "mp3") {
            if let audioPlayer = try? AVAudioPlayer(contentsOf: musicURL) {
                music = audioPlayer
                music.numberOfLoops = -1
                music.play()
            }
        }
    }

}

