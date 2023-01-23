//
//  ViewController.swift
//  project-10-sbl
//
//  Created by Diogo Melo on 2/24/22.
//

import UIKit

class ViewController: UICollectionViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
var people = [Person]()
    
    override func loadView() {
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        
        layout.itemSize = CGSize(width: 140, height: 180)
        
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        
        collectionView.register(PersonCell.self, forCellWithReuseIdentifier: "Person")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.backgroundColor = .black
        
        let defaults = UserDefaults.standard
        if let savedData = defaults.object(forKey: "people") as? Data {
            if let decodedPeople = try? NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(savedData) as? [Person] {
                people = decodedPeople
            }
        }
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addNewPerson))
    }
    
    @objc func addNewPerson () {
        let picker = UIImagePickerController()
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
//            picker.sourceType = .camera
        }
        picker.allowsEditing = true

        picker.delegate = self
        present(picker, animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[.editedImage] as? UIImage else { return }
        
    let imageName = UUID().uuidString
    let imagePath = getDocumentsDirectory().appendingPathComponent(imageName)
        
    if let jpegData = image.jpegData(compressionQuality: 0.8) {
        try? jpegData.write(to: imagePath)
    }
    
        let person = Person(name: "Unknown", image: imageName)
        people.append(person)
        collectionView.reloadData()
    
        dismiss(animated: true)
        save()
        }
    
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return people.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Person", for: indexPath) as? PersonCell else {
            fatalError("Unable to dequeue PersonCell.")
        }
        
        let person = people[indexPath.item]
        
        cell.name.text = person.name
        let path = getDocumentsDirectory().appendingPathComponent(person.image)
        cell.imageView.image = UIImage(contentsOfFile: path.path)
        
        cell.imageView.layer.borderColor = UIColor(white: 0, alpha: 0.3).cgColor
        cell.imageView.layer.borderWidth = 2
        cell.imageView.layer.cornerRadius = 3
        cell.layer.cornerRadius = 7
        
        return cell
    }

    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let person = people[indexPath.item]
        
        let ac = UIAlertController(title: "\(person.name)", message: nil, preferredStyle: .alert)
        
        ac.addAction(UIAlertAction(title: "Edit name", style: .default) { [weak self] _ in
            self?.editName(for: person)
        })
                     
        ac.addAction(UIAlertAction(title: "Delete", style: .destructive) { [weak self] _ in
            self?.removePerson(at: indexPath.item)
        })
        present(ac, animated: true)
    }
        
        func editName (for person: Person) {
        let ac = UIAlertController(title: "Change name", message: nil, preferredStyle: .alert)
        ac.addTextField()
        
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
                     
                     ac.addAction(UIAlertAction(title: "OK", style: .default) { [weak self, weak ac] _ in
                         guard let newName = ac?.textFields?[0].text else {return}
                         person.name = newName
                         self?.collectionView.reloadData()
                         self?.save()
        })
                     
                     present(ac, animated: true)
    }
    
    func removePerson (at index: Int) {
        people.remove(at: index)
        collectionView.reloadData()
        save()
    }
    
    func save () {
        if let saveData = try? NSKeyedArchiver.archivedData(withRootObject: people, requiringSecureCoding: false) {
            let defaults = UserDefaults.standard
            defaults.set(saveData, forKey: "people")
        }
    }
}

