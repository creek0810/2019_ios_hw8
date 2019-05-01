//
//  gameViewController.swift
//  2019_ios_hw8
//
//  Created by 王心妤 on 2019/4/30.
//  Copyright © 2019年 river. All rights reserved.
//

import UIKit

class gameViewController: UIViewController {
    var puzzle: Puzzle?
    var timer: Timer?
    var count: Int = 0
    
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet var btnCollection: [UIButton]!
    @IBOutlet var puzzleImage: [UIImageView]!
    
    @IBAction func btnPressed(_ sender: UIButton) {
        let dir = [[1, 0], [-1, 0], [0, 1], [0, -1]]
        var result: Bool?
        for i in 0...3 {
            if sender == btnCollection[i] {
                result = puzzle?.move(row: dir[i][0], col: dir[i][1])
                updateImage(list: puzzle?.table)
                break
            }
        }
        if let result = result, let timer = timer {
            if result {
                print("finish")
                timer.invalidate()
            }else{
                let tmp = puzzle?.updateBtn()
                disablBtn(list: tmp!)
            }
        }
    }
    
    @IBAction func gameStart(_ sender: Any) {
        disablBtn(list: [Int]())
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { (_) in
            self.count += 1
            let secInt = Int(self.count)%60
            
            let minsInt = Int(self.count/60)%60
            let hourInt = Int(self.count/3600)%24
            self.timeLabel.text = "\(hourInt):\(minsInt):\(secInt)"
            
        }
    }
    
    func disablBtn(list: [Int]) {
        print(list)
        for i in btnCollection {
            i.isEnabled = true
        }
        for i in list {
            btnCollection[i].isEnabled = false
        }
    }
    
    func updateImage(list: [[Int]]?){
        if let list = list {
            var count = -1
            print("update ")
            for i in list {
                for j in i {
                    count += 1
                    if j == -1 {
                        puzzleImage[count].image = nil
                        continue
                    }
                    puzzleImage[count].image = UIImage(named: "\(j+1)")
                }
            }
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        var image: [UIImage] = [UIImage]();
        for i in 1...8 {
            var tmp = UIImage(named: "\(i).png")
            if let tmp = tmp {
                image.append(tmp)
            }
        }
        
        puzzle = Puzzle(image: image, name: "hello")
        let seq = puzzle?.shuffle()
        if let seq = seq {
            var count = -1
            for i in seq {
                for j in i {
                    count += 1
                    if j == -1 {
                        continue
                    }
                    puzzleImage[count].image = UIImage(named: "\(j+1)")
                    
                }
            }
        }
        let tmp = puzzle?.updateBtn()
        disablBtn(list: tmp!)
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
