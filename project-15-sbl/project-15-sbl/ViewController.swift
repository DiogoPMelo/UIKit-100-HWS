//
//  ViewController.swift
//  project-15-sbl
//
//  Created by Diogo Melo on 3/1/22.
//

import UIKit

class ViewController: UIViewController {
    var button: UIButton!
    var imageView: UIImageView!
    var currentAnimation = -2
    
    override func loadView() {
        super.loadView()
        
        button = UIButton()
        button.backgroundColor = .white
        button.setTitle("tap", for: .normal)
        button.addTarget(self, action: #selector(tap), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(button)
        
        NSLayoutConstraint.activate([
            button.topAnchor.constraint(greaterThanOrEqualTo: view.safeAreaLayoutGuide.centerYAnchor),
            button.bottomAnchor.constraint(lessThanOrEqualTo: view.safeAreaLayoutGuide.bottomAnchor),
            button.heightAnchor.constraint(equalToConstant: 50),
            button.widthAnchor.constraint(equalTo: button.heightAnchor),
            button.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor)
        ])
        
        imageView = UIImageView(image: UIImage(named: "penguin"))
        imageView.center = CGPoint(x: 512, y: 384)
        imageView.isAccessibilityElement = true
        imageView.accessibilityLabel = "Pingu"
        view.addSubview(imageView)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    @objc func tap (_ sender: UIButton) {
        sender.isHidden = true

        if currentAnimation == -2 {
            self.imageView.bounceOut(duration: 5, preAction: {
                sender.isHidden = true
            }) { _ in
                sender.isHidden = false
            }
        }
        
        UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 5, options: [],
           animations: {
            switch self.currentAnimation {
            case -1:
                self.imageView.transform = .identity
            case 0:
                self.imageView.transform = CGAffineTransform(scaleX: 2, y: 2)
            case 1:
                self.imageView.transform = .identity
            case 2:
                self.imageView.transform = CGAffineTransform(translationX: -256, y: -256)
            case 3:
                self.imageView.transform = .identity
            case 4:
                self.imageView.transform = CGAffineTransform(rotationAngle: CGFloat.pi)
            case 5:
                self.imageView.transform = .identity
            case 6:
                self.imageView.alpha = 0.1
                self.imageView.backgroundColor = UIColor.green
            case 7:
                self.imageView.alpha = 1
                self.imageView.backgroundColor = UIColor.clear
            default:
                break
            }
        }) { finished in
            sender.isHidden = false
        }

        currentAnimation += 1

        if currentAnimation > 7 {
            currentAnimation = -2
        }
    }

}

// project 82 challenge 1

extension UIView {
    func bounceOut (duration: Double, preAction: (() -> Void)? = nil, completion: ((Bool) -> Void)? = nil) {
        preAction?()
        UIView.animate(withDuration: duration, delay: 0, options: [], animations: {
            self.transform = CGAffineTransform(scaleX: 0.0001, y: 0.0001)
        }) { finished in
            completion?(finished)
        }
    }
}
