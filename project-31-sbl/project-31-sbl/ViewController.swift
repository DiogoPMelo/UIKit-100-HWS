//
//  ViewController.swift
//  project-31-sbl
//
//  Created by Diogo Melo on 4/5/22.
//

import UIKit
import WebKit

class ViewController: UIViewController, WKNavigationDelegate, UITextFieldDelegate, UIGestureRecognizerDelegate {
    var addressBar: UITextField!
    var stackView: UIStackView!
    weak var activeWebView: WKWebView?
    
    override func loadView() {
        super.loadView()
        
        addressBar = UITextField()
        addressBar.placeholder = "Adress bar"
        addressBar.autocorrectionType = .no
        addressBar.autocapitalizationType = .none
        addressBar.smartDashesType = .no
        addressBar.smartQuotesType = .no
        addressBar.addTarget(self, action: #selector(textFieldShouldReturn), for: .primaryActionTriggered)
        addressBar.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(addressBar)
        
        stackView = UIStackView()
        stackView.distribution = .fillEqually
        stackView.spacing = 5
        stackView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(stackView)
        
        NSLayoutConstraint.activate([
            addressBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 5),
            addressBar.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 5),
            addressBar.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: 5),
            addressBar.bottomAnchor.constraint(equalTo: stackView.topAnchor, constant: 5),
            
            stackView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
            
        ])
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setDefaultTitle()
        
        let add = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addWebView))
        let delete = UIBarButtonItem(barButtonSystemItem: .trash, target: self, action: #selector(deleteWebView))
        navigationItem.rightBarButtonItems = [delete, add]
        
    }

    func setDefaultTitle() {
        title = "Multi Browser"
    }
    
    func updateUI (_ webView: WKWebView) {
        title = webView.title ?? "Multi Browser"
        addressBar.text = webView.url?.absoluteString ?? ""
    }
    
    @objc func addWebView(_ sender: UIBarButtonItem? = nil) {
        let webView = WKWebView()
        webView.navigationDelegate = self
        
        stackView.addArrangedSubview(webView)
        
        let url = URL(string: "https://www.hackingwithswift.com")!
        webView.load(URLRequest(url: url))
        webView.layer.borderColor = UIColor.blue.cgColor
        selectWebView(webView)
        
        let recognizer = UITapGestureRecognizer(target: self, action: #selector(webViewTapped))
        recognizer.delegate = self
        webView.addGestureRecognizer(recognizer)
    }
    
    func selectWebView (_ webView: WKWebView) {
        var index = -1
        for (i, view) in stackView.arrangedSubviews.enumerated() {
            view.layer.borderWidth = 0
            if view == webView {
                index = i
            }
        }
        
        activeWebView = webView
        webView.layer.borderWidth = 3
updateUI(webView)
        
        UIAccessibility.post(notification: .announcement, argument: "Tab \(index + 1) active")
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        if webView == activeWebView {
            updateUI(webView)
        }
    }
    
    @objc func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if activeWebView == nil {
            addWebView()
        }
        
        if let webView = activeWebView, let address = addressBar.text {
            var improvedAddress = address
            if address.hasPrefix("https://www.") {
                improvedAddress = "https://www." + address
        } else if !address.hasPrefix("https://") {
                improvedAddress = "https://" + address
            }
            if let url = URL(string: improvedAddress) {
                webView.load(URLRequest(url: url))
            }
        }
        
        textField.resignFirstResponder()
        return true
    }
    
    @objc func webViewTapped (_ recognizer: UITapGestureRecognizer) {
        if let selectedWebView = recognizer.view as? WKWebView {
            selectWebView(selectedWebView)
        }
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
    @objc func deleteWebView(_ sender: UIBarButtonItem) {
        guard let webView = activeWebView, let index = stackView.arrangedSubviews.firstIndex(of: webView) else {
            return
        }
        webView.removeFromSuperview()
        
        if stackView.arrangedSubviews.isEmpty {
            setDefaultTitle()
        } else {
            var currentIndex = Int(index)
            
            if currentIndex == stackView.arrangedSubviews.count {
                currentIndex = stackView.arrangedSubviews.count - 1
            }

            if let newSelectedWebView = stackView.arrangedSubviews[currentIndex] as? WKWebView {
                selectWebView(newSelectedWebView)
            }
        }
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        if traitCollection.horizontalSizeClass == .compact {
            stackView.axis = .vertical
        } else {
            stackView.axis = .horizontal
        }
    }

}

