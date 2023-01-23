//
//  ViewController.swift
//  Anchors
//
//  Created by Diogo Melo on 2/12/22.
//

import UIKit

class ViewController: UIViewController {

    weak var testView: UIView!
    weak var test2View: UIView!

    override func loadView() {
        super.loadView()

        let centeredView = UIView(frame: .zero)
        centeredView.accessibilityLabel = "Centred anchor"
        centeredView.accessibilityHint = "View placed with center anchors"
        centeredView.isAccessibilityElement = true
        centeredView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(centeredView)
        NSLayoutConstraint.activate([
            centeredView.widthAnchor.constraint(equalToConstant: 100),
            centeredView.heightAnchor.constraint(equalTo: centeredView.widthAnchor, multiplier: 16/9),
            centeredView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor, constant: -100),
            centeredView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor, constant: 100),
        ])
        self.testView = centeredView
        
        let boardered = UIView(frame: .zero)
        boardered.accessibilityLabel = "Boarder anchor"
        boardered.accessibilityHint = "View placed with boarder anchors"
        boardered.isAccessibilityElement = true
        boardered.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(boardered)
        NSLayoutConstraint.activate([
            boardered.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 100),
            boardered.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            boardered.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            boardered.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: -100),
        ])
        self.test2View = boardered
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        self.testView.backgroundColor = .yellow
        self.test2View.backgroundColor = .white
    }
}
