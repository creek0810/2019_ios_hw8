//
//  WallpaperViewController.swift
//  2019_ios_hw8
//
//  Created by 王心妤 on 2019/5/6.
//  Copyright © 2019年 river. All rights reserved.
//

import UIKit

class WallpaperViewController: UIViewController {
    
    var imageSet: [UIImage] = [UIImage]()
    var currentPage:Int = 0

    @IBOutlet weak var pageLabel: UILabel!
    @IBOutlet var wallpaperCollection: [UIButton]!
    
    @IBAction func preSet(_ sender: Any) {
        if currentPage != 0{
            currentPage -= 1
            updateUI() 
        }
    }
    
    @IBAction func nextSet(_ sender: Any) {
        if currentPage != 3{
            currentPage += 1
            updateUI()
        }
    }
    
    @IBAction func wallpaperSelected(_ sender: UIButton) {
        var loc = -1
        for i in 0...3 {
            if wallpaperCollection[i] == sender {
                loc = i
                break
            }
        }
        let puzzleName = "default\(currentPage * 4 + loc + 1)"
        let defaultPersonalScore = [puzzleName: false]
        UserDefaults.standard.register(defaults: defaultPersonalScore)
        
        let haveFinish = UserDefaults.standard.bool(forKey: puzzleName)
        if haveFinish {
            self.performSegue(withIdentifier: "showWallpaper", sender: sender.image(for: .normal))
        } else {
            print("you should pass the game first")
        }
        
    }
    
    func initUI() {
        for i in 1...16 {
            if let image = UIImage(named: "wallpaper\(i)") {
                imageSet.append(image)
            }
        }
        for i in 0...3 {
            wallpaperCollection[i].setImage(imageSet[i], for: .normal)
        }
    }
    
    func updateUI () {
        let start = 4 * currentPage
        for i in 0...3 {
            wallpaperCollection[i].setImage(imageSet[i + start], for: .normal)
            pageLabel.text = "\(currentPage + 1) / 4"

        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initUI()
    }
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let image = sender as! UIImage
        let controller = segue.destination as! ShareWallpaperViewController
        controller.wallpaperImage = image
    }
    

}
