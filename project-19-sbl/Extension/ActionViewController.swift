//
//  ActionViewController.swift
//  Extension
//
//  Created by Diogo Melo on 3/4/22.
//

import UIKit
import MobileCoreServices
import UniformTypeIdentifiers

@objc (ActionViewController)

    class ActionViewController: UIViewController {

    var script: UITextView!
    var titleLabel: UILabel!
    var pageTitle = ""
    var pageURL = ""
    
    override func loadView() {
        super.loadView()
        
        
        
        titleLabel = UILabel()
        titleLabel.text = "Title here"
        titleLabel.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        view.addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        let doneBtn = UIButton()
        doneBtn.setTitle("done", for: .normal)
        doneBtn.addTarget(self, action: #selector(done), for: .touchUpInside)
        view.addSubview(doneBtn)
        doneBtn.translatesAutoresizingMaskIntoConstraints = false
        
        script = UITextView()
        script.autocorrectionType = .no
        script.autocapitalizationType = .none
        script.spellCheckingType = .no
        script.smartDashesType = .no
        script.smartInsertDeleteType = .no
        script.smartQuotesType = .no
        view.addSubview(script)
        script.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            titleLabel.trailingAnchor.constraint(lessThanOrEqualTo: doneBtn.leadingAnchor, constant: -10),
            
            doneBtn.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            doneBtn.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            script.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            script.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            script.heightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.heightAnchor, multiplier: 0.7),
            script.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 10)
        ])
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let inputItem = extensionContext?.inputItems.first as? NSExtensionItem {
            if let itemProvider = inputItem.attachments?.first {
                itemProvider.loadItem(forTypeIdentifier: kUTTypePropertyList as String) { [weak self] (dict, error) in
                    guard let itemDictionary = dict as? NSDictionary else { return }
                    guard let javaScriptValues = itemDictionary[NSExtensionJavaScriptPreprocessingResultsKey] as? NSDictionary else { return }
                    self?.pageTitle = javaScriptValues["title"] as? String ?? ""
                    self?.pageURL = javaScriptValues["URL"] as? String ?? ""
                    
                    DispatchQueue.main.async {
                        self?.titleLabel.text = self?.pageTitle
                    }
                }
            }
        }
        
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillHideNotification, object: nil)
        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
    }
    
    @objc func adjustForKeyboard(notification: Notification) {
        guard let keyboardValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }

        let keyboardScreenEndFrame = keyboardValue.cgRectValue
        let keyboardViewEndFrame = view.convert(keyboardScreenEndFrame, from: view.window)

        if notification.name == UIResponder.keyboardWillHideNotification {
            script.contentInset = .zero
        } else {
            script.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardViewEndFrame.height - view.safeAreaInsets.bottom, right: 0)
        }

        script.scrollIndicatorInsets = script.contentInset

        let selectedRange = script.selectedRange
        script.scrollRangeToVisible(selectedRange)
    }
    

    @objc func done() {
        let item = NSExtensionItem()
        let argument: NSDictionary = ["customJavaScript": script.text]
        let webDictionary: NSDictionary = [NSExtensionJavaScriptFinalizeArgumentKey: argument]
        let customJavaScript = NSItemProvider(item: webDictionary, typeIdentifier: kUTTypePropertyList as String)
        item.attachments = [customJavaScript]

        extensionContext?.completeRequest(returningItems: [item])
    }

}
