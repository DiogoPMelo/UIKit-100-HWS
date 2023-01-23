//
//  ViewController.swift
//  challenge-4
//
//  Created by Diogo Melo on 2/26/22.
//

import UIKit

class ViewController: UITableViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
var pics = [ImageObj]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Image")
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addImage))
        
        let defaults = UserDefaults.standard
        if let savedData = defaults.object(forKey: "pics") as? Data {
            if let savedPics = try? JSONDecoder().decode([ImageObj].self, from: savedData) {
                pics = savedPics
            }
        }
    }

    @objc func addImage () {
        let picker = UIImagePickerController()
        
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            picker.sourceType = .camera
        }
        picker.allowsEditing = true
        
        picker.delegate = self
        present(picker, animated: true)
    }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[.editedImage] as? UIImage else {return}
        
        let imageName = UUID().uuidString
        let imagePath = getDocumentsDirectory().appendingPathComponent(imageName)
        
        if let jpegData = image.jpegData(compressionQuality: 0.8) {
            try? jpegData.write(to: imagePath)
        }
        
        let imageObj = ImageObj(name: "Unknown", image: imageName)
        
        dismiss(animated: true)
        
        let ac = UIAlertController(title: "Picture name", message: nil, preferredStyle: .alert)
        ac.addTextField()
        ac.addAction(UIAlertAction(title: "Done", style: .default) { [weak self, weak ac] _ in
            guard let name = ac?.textFields?[0].text else {return}
            let nameToSave = name == "" ? "Unknown" : name
            imageObj.name = nameToSave
            self?.pics.append(imageObj)
            self?.save()
        })
        present(ac, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        pics.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Image", for: indexPath)

        cell.textLabel?.text = pics[indexPath.row].name
        let imagePath = getDocumentsDirectory().appendingPathComponent(pics[indexPath.row].image)
        cell.imageView?.image = UIImage(contentsOfFile: imagePath.path)
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let detail = DetailView()
        detail.data = pics[indexPath.row]
        navigationController?.pushViewController(detail, animated: true)
    }
    func save () {
        tableView.reloadData()
        if let saveData = try? JSONEncoder().encode(pics) {
        let defaults = UserDefaults.standard
            defaults.set(saveData, forKey: "pics")
        }
    }
    
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
}

