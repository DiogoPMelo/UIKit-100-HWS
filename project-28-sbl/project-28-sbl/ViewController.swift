//
//  ViewController.swift
//  project-28-sbl
//
//  Created by Diogo Melo on 3/21/22.
//

import LocalAuthentication
import UIKit

class ViewController: UIViewController {
    var secret: UITextView!
    var authenticateButton: UIButton!
    var doneButton: UIBarButtonItem!
    
    override func loadView() {
        super.loadView()
        
        secret = UITextView()
        view.addSubview(secret)
        secret.translatesAutoresizingMaskIntoConstraints = false
        
        authenticateButton = UIButton()
        authenticateButton.setTitle("Authenticate", for: .normal)
        authenticateButton.addTarget(self, action: #selector(authenticateTapped), for: .touchUpInside)
        view.addSubview(authenticateButton)
        authenticateButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            secret.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            secret.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            secret.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            secret.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            
            authenticateButton.heightAnchor.constraint(equalToConstant: 44),
            authenticateButton.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            authenticateButton.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor)
        ])
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillHideNotification, object: nil)
        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
        notificationCenter.addObserver(self, selector: #selector(saveSecretMessage), name: UIApplication.willResignActiveNotification, object: nil)
        
        secret.isHidden = true
        title = "Nothing to see here"
        doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(saveSecretMessage))
        
        guard let _ = KeychainWrapper.standard.string(forKey: "password") else {
        KeychainWrapper.standard.set("a", forKey: "password")
            return
        }
    }
    
    @objc func adjustForKeyboard(notification: Notification) {
        guard let keyboardValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }

        let keyboardScreenEndFrame = keyboardValue.cgRectValue
        let keyboardViewEndFrame = view.convert(keyboardScreenEndFrame, from: view.window)

        if notification.name == UIResponder.keyboardWillHideNotification {
            secret.contentInset = .zero
        } else {
            secret.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardViewEndFrame.height - view.safeAreaInsets.bottom, right: 0)
        }

        secret.scrollIndicatorInsets = secret.contentInset

        let selectedRange = secret.selectedRange
        secret.scrollRangeToVisible(selectedRange)
    }

    @objc func authenticateTapped (_ sender: UIButton) {
        let context = LAContext()
        var error: NSError?
        
        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            let reason = "Identify yourself!"
            
            context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) { [weak self] success, authenticationError in
                DispatchQueue.main.async {
                    if success {
                        self?.unlockSecretMessage()
                    } else {
                        let ac = UIAlertController(title: "Authentication failed", message: "You could not be verified; please try again or use the password.", preferredStyle: .alert)
                        ac.addTextField()
                        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
                                     ac.addAction(UIAlertAction(title: "OK", style: .default) { [weak self, weak ac] _ in
                                         guard let text = ac?.textFields?[0].text else {
                                             return
                                         }
                                         if let password = KeychainWrapper.standard.string(forKey: "password") {
                                             if text == password {
                                                 self?.unlockSecretMessage()
                                             }
                                         }
                        })
                        self?.present(ac, animated: true)
                    }
                }
            }
        } else {
            let ac = UIAlertController(title: "Biometry unavailable", message: "Your device is not configured for biometric authentication.", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
            self.present(ac, animated: true)
        }
    }
    
    func unlockSecretMessage() {
        secret.isHidden = false
        authenticateButton.isHidden = true
        navigationItem.rightBarButtonItem = doneButton
        title = "Secret stuff!"

            secret.text = KeychainWrapper.standard.string(forKey: "SecretMessage")
    }
    
    @objc func saveSecretMessage() {
        guard secret.isHidden == false else { return }

        KeychainWrapper.standard.set(secret.text, forKey: "SecretMessage")
        secret.resignFirstResponder()
        secret.isHidden = true
        authenticateButton.isHidden = false
        title = "Nothing to see here"
        navigationItem.rightBarButtonItem = nil
    }

}

