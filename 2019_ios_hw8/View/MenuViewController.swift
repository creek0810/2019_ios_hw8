//
//  MenuViewController.swift
//  2019_ios_hw8
//
//  Created by 王心妤 on 2019/5/4.
//  Copyright © 2019年 river. All rights reserved.
//

import UIKit

class MenuViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    var defaultImage: [UIImage] = [UIImage]()
    var selectedImage: UIImage?
    
    @IBOutlet weak var menuTable: UITableView!
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if defaultImage.count >= 1{
            return defaultImage.count + 1
        } else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MenuTableViewCell", for: indexPath) as! MenuTableViewCell
        if(indexPath.row == defaultImage.count) {
            cell.puzzleNameLabel.text = "自選圖片"
        } else {
            cell.puzzleNameLabel.text = "default \(indexPath.row)"
            cell.puzzleImage.image = defaultImage[indexPath.row]
        }
        return cell
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let selectedImage = info[.originalImage] as? UIImage else {
            fatalError("Expected a dictionary containing an image, but was provided the following: \(info)")
        }
        dismiss(animated: true) {
            self.performSegue(withIdentifier: "goGameController", sender: selectedImage)
        }
    }
    
    func pickPicture() {
        let controller = UIImagePickerController()
        controller.sourceType = .photoLibrary
        controller.delegate = self
        present(controller, animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == defaultImage.count {
            pickPicture()
        }else{
            self.performSegue(withIdentifier: "goGameController", sender: defaultImage[indexPath.row])
        }
    }

    func cutImage(originalImage: UIImage) -> [UIImage] {
        var result: [UIImage] = [UIImage]()
        
        let oriHeight = Double(originalImage.size.height)
        let oriWidth = Double(originalImage.size.width)
        let max = oriHeight > oriWidth ? oriWidth : oriHeight
        let square = max / 3
        
        let oriCGImage = originalImage.cgImage
        if let image = oriCGImage {
            for i in 0...2 {
                for j in 0...2 {
                    let newCGImage = image.cropping(to: CGRect(x: (oriWidth - max) / 2 + Double(j) * square, y: (oriHeight - max) / 2 + Double(i) * square, width: square, height: square))
                    let tmp = UIImage(cgImage: newCGImage!)
                    result.append(tmp)
                }
            }
        }
        return result
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        menuTable.delegate = self
        menuTable.dataSource = self
        menuTable.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        
        for i in 1...3 {
            defaultImage.append(UIImage(named: "default\(i)")!)
        }
        menuTable.reloadData()
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let image = sender as! UIImage
        
        let controller = segue.destination as! gameViewController
        controller.puzzle = Puzzle(image: cutImage(originalImage: image), name: "hello")
    }
    

}
