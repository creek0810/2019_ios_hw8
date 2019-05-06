//
//  ShareWallpaperViewController.swift
//  2019_ios_hw8
//
//  Created by 王心妤 on 2019/5/5.
//  Copyright © 2019年 river. All rights reserved.
//

import UIKit

class ShareWallpaperViewController: UIViewController {
    var wallpaperImage: UIImage?
    @IBOutlet weak var wallpaperImageView: UIImageView!
    
    @IBAction func shareScore(_ sender: Any) {
        if let image = wallpaperImageView.image {
            let activityViewController = UIActivityViewController(activityItems: [image], applicationActivities: nil)
            self.present(activityViewController, animated: true, completion: nil)
        }
    }
    
    func initUI() {
        if let wallpaperImage = wallpaperImage {
            wallpaperImageView.image = wallpaperImage
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initUI()

        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
