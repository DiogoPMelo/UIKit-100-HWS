//
//  DetailView.swift
//  challenge-6-notes
//
//  Created by Diogo Melo on 3/7/22.
//

import UIKit

class DetailViewController: UIViewController {
    var textView: UITextView!
    var note = ""
    var index = 0
    weak var owner: ViewController!
    
    override func loadView() {
        super.loadView()
        
        textView = UITextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(textView)
        
        NSLayoutConstraint.activate([
            textView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            textView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            textView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 30),
            textView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
        
        let components = note.components(separatedBy: "\n")
        if let firstLine = components.first {
            title = firstLine
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        textView.text = note
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        owner?.notes[index] = textView.text
        owner?.save()
    }
}
