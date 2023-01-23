//
//  ViewController.swift
//  project-13-sbl
//
//  Created by Diogo Melo on 2/28/22.
//

import UIKit
import CoreImage

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    var uiView: UIView!
    var imageView: UIImageView!
    enum FilterParameters: String, CaseIterable {
        case Intensity, Radius, Scale, Center
    }
    lazy var parameters: [FilterParameters: (label: UILabel,slider:  UISlider, isShowing: Bool)] = {
        var parameters = [FilterParameters: (label: UILabel,slider:  UISlider, isShowing: Bool)]()
        for param in FilterParameters.allCases {
            let label = UILabel()
            label.translatesAutoresizingMaskIntoConstraints = false
            label.text = param.rawValue
           label.textAlignment = .right
                        
            let slider = UISlider()
            slider.addTarget(self, action: #selector(changeIntensity), for: .valueChanged)
            slider.translatesAutoresizingMaskIntoConstraints = false
            parameters[param] = (label, slider, true)
        }
        return parameters
    }()
    
    var changeBtn: UIButton!
    var currentImage: UIImage!
    var context: CIContext!
    var currentFilter: CIFilter!
    var filterName = "" {
        didSet {
            currentFilter = CIFilter(name: filterName)
            changeBtn.setTitle("Change \(filterName) filter", for: .normal)
            
            let inputKeys = currentFilter.inputKeys
            
            parameters[.Intensity]?.isShowing = inputKeys.contains(kCIInputIntensityKey)
            parameters[.Radius]?.isShowing = inputKeys.contains(kCIInputRadiusKey)
            parameters[.Scale]?.isShowing = inputKeys.contains(kCIInputScaleKey)
            parameters[.Center]?.isShowing = inputKeys.contains(kCIInputCenterKey)
            
            mutableButtonsPlacement()
        }
    }
    
    override func loadView() {
        super.loadView()
        uiView = UIView()
        uiView.translatesAutoresizingMaskIntoConstraints = false
        uiView.backgroundColor = .darkGray
        view.addSubview(uiView)
        
        imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        uiView.addSubview(imageView)
        
        changeBtn = UIButton()
        changeBtn.addTarget(self, action: #selector(changeFilter), for: .touchUpInside)
        changeBtn.translatesAutoresizingMaskIntoConstraints = false
        changeBtn.setTitle("Change filter", for: .normal)
        view.addSubview(changeBtn)
        
        let saveBtn = UIButton()
        saveBtn.addTarget(self, action: #selector(save), for: .touchUpInside)
        saveBtn.translatesAutoresizingMaskIntoConstraints = false
        saveBtn.setTitle("Save", for: .normal)
        view.addSubview(saveBtn)
        
        NSLayoutConstraint.activate([
            uiView.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor, constant: 10),
            uiView.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor),
            uiView.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor),
            uiView.centerXAnchor.constraint(equalTo: view.layoutMarginsGuide.centerXAnchor),
            uiView.heightAnchor.constraint(lessThanOrEqualTo: view.layoutMarginsGuide.heightAnchor, multiplier: 0.7), uiView.heightAnchor.constraint(greaterThanOrEqualTo: view.layoutMarginsGuide.heightAnchor, multiplier: 0.6),
            
            imageView.topAnchor.constraint(equalTo: uiView.topAnchor, constant: 10),
            imageView.heightAnchor.constraint(equalTo: uiView.heightAnchor, constant: -20),
            imageView.widthAnchor.constraint(equalTo: imageView.heightAnchor, multiplier: 355/450),
            imageView.leadingAnchor.constraint(greaterThanOrEqualTo: uiView.leadingAnchor, constant: 10),
            imageView.trailingAnchor.constraint(lessThanOrEqualTo: uiView.trailingAnchor, constant: -10),
            imageView.bottomAnchor.constraint(equalTo: uiView.bottomAnchor, constant: -10),
            imageView.centerXAnchor.constraint(equalTo: uiView.centerXAnchor),
            
            changeBtn.bottomAnchor.constraint(equalTo: view.layoutMarginsGuide.bottomAnchor, constant: 16),
            changeBtn.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor, constant: 16),
            
            saveBtn.topAnchor.constraint(equalTo: changeBtn.topAnchor),
            saveBtn.heightAnchor.constraint(equalTo: changeBtn.heightAnchor),
            saveBtn.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor, constant: -16)
        ])
        
    }
    
    func mutableButtonsPlacement() {
        var previousAnchor = uiView.bottomAnchor
        
        for param in parameters.values {
            if param.isShowing {
                view.addSubview(param.label)
                view.addSubview(param.slider)
                
                NSLayoutConstraint.activate([
                    param.label.topAnchor.constraint(equalTo: previousAnchor, constant: 20),
                    param.label.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.centerXAnchor, constant: -20),
                    param.label.widthAnchor.constraint(lessThanOrEqualTo: view.layoutMarginsGuide.widthAnchor, multiplier: 0.3, constant: -20),
                    
                    param.slider.centerYAnchor.constraint(equalTo: param.label.centerYAnchor),
                    param.slider.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.centerXAnchor, constant: 20),
                    param.slider.widthAnchor.constraint(equalTo: param.label.widthAnchor),
                ])
                
                previousAnchor = param.label.bottomAnchor
            } else {
                param.label.removeFromSuperview()
                param.slider.removeFromSuperview()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "InstaFilter"
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(importPicture))
        
        context = CIContext()
        filterName = "CISepiaTone"
    }
    
    @objc func importPicture () {
        let picker = UIImagePickerController()
        picker.allowsEditing = true
        picker.delegate = self
        present(picker, animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[.editedImage] as? UIImage else {return}
        dismiss(animated: true)
        currentImage = image
        
        let beginImage = CIImage(image: currentImage)
        currentFilter.setValue(beginImage, forKey: kCIInputImageKey)
        
        imageView.alpha = 0.1
        UIView.animate(withDuration: 0.3, delay: 0, options: [], animations: {
            self.imageView.alpha = 1
        }) { finished in
            self.applyProcessing()
        }
    }
    
    @objc func changeIntensity (_ sender: UISlider) {
        applyProcessing()
    }
    
    @objc func save (_ sender: Any) {
        guard let image = imageView.image else {
            let ac = UIAlertController(title: "Error", message: "No image selected", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
            present(ac, animated: true)
            return
            
        }
        
        UIImageWriteToSavedPhotosAlbum(image, self, #selector(image(_:didFinishSavingWithError:contextInfo:)), nil)
    }
    
    @objc func image(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
        if let error = error {
            // we got back an error!
            let ac = UIAlertController(title: "Save error", message: error.localizedDescription, preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
            present(ac, animated: true)
        } else {
            let ac = UIAlertController(title: "Saved!", message: "Your altered image has been saved to your photos.", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
            present(ac, animated: true)
        }
    }
    
    @objc func changeFilter (_ sender: Any) {
        let ac = UIAlertController(title: "Choose filter", message: nil, preferredStyle: .actionSheet)
        ac.addAction(UIAlertAction(title: "CIBumpDistortion", style: .default, handler: setFilter))
        ac.addAction(UIAlertAction(title: "CIGaussianBlur", style: .default, handler: setFilter))
        ac.addAction(UIAlertAction(title: "CIPixellate", style: .default, handler: setFilter))
        ac.addAction(UIAlertAction(title: "CISepiaTone", style: .default, handler: setFilter))
        ac.addAction(UIAlertAction(title: "CITwirlDistortion", style: .default, handler: setFilter))
        ac.addAction(UIAlertAction(title: "CIUnsharpMask", style: .default, handler: setFilter))
        ac.addAction(UIAlertAction(title: "CIVignette", style: .default, handler: setFilter))
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        present(ac, animated: true)
    }
    
    func setFilter(action: UIAlertAction) {
        // make sure we have a valid image before continuing!
        guard currentImage != nil else { return }

        // safely read the alert action's title
        guard let actionTitle = action.title else { return }

        filterName = actionTitle
        
        let beginImage = CIImage(image: currentImage)
        currentFilter.setValue(beginImage, forKey: kCIInputImageKey)

        applyProcessing()
    }
    
    func applyProcessing() {
        guard imageView.image != nil else {
            return
        }
        
        let inputKeys = currentFilter.inputKeys

        if inputKeys.contains(kCIInputIntensityKey) { currentFilter.setValue(parameters[.Intensity]?.slider.value, forKey: kCIInputIntensityKey) }
        if inputKeys.contains(kCIInputRadiusKey) {currentFilter.setValue(parameters[.Radius]?.slider.value ?? 50 * 200, forKey: kCIInputRadiusKey) }
        if inputKeys.contains(kCIInputScaleKey) { currentFilter.setValue(parameters[.Scale]?.slider.value ?? 50 * 10, forKey: kCIInputScaleKey) }
        if inputKeys.contains(kCIInputCenterKey) { currentFilter.setValue(CIVector(x: currentImage.size.width / 2, y: currentImage.size.height / 2), forKey: kCIInputCenterKey) }

        if let cgimg = context.createCGImage(currentFilter.outputImage!, from: currentFilter.outputImage!.extent) {
            let processedImage = UIImage(cgImage: cgimg)
            self.imageView.image = processedImage
        }
    }
    
}

