//
//  gameViewController.swift
//  2019_ios_hw8
//
//  Created by 王心妤 on 2019/4/30.
//  Copyright © 2019年 river. All rights reserved.
//

import UIKit
import UserNotifications

class gameViewController: UIViewController {
    
    var puzzle: Puzzle?
    var timer: Timer?
    var count: Int = 0
    
    @IBOutlet var btnCollection: [UIButton]!
    @IBOutlet var puzzleImage: [UIImageView]!
    @IBOutlet var timeLabel: UILabel!
    
    @IBAction func test(_ sender: Any) {
        getUserName()
    }

    @IBAction func createNotification(_ sender: AnyObject) {
        let content = UNMutableNotificationContent()
        content.title = "體驗過了，才是你的。"
        content.subtitle = "米花兒"
        content.body = "不要追問為什麼，就笨拙地走入未知。感受眼前的怦然與顫抖，聽聽左邊的碎裂和跳動。不管好的壞的，只有體驗過了，才是你的。"
        content.badge = 1
        content.sound = UNNotificationSound.default
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 10, repeats: false)
        let request = UNNotificationRequest(identifier: "notification1", content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
    }
    
    
    @IBAction func btnPressed(_ sender: UIButton) {
        let dir = [[1, 0], [-1, 0], [0, 1], [0, -1]]
        var isFinish: Bool?
        for i in 0...3 {
            if sender == btnCollection[i] {
                isFinish = puzzle?.move(row: dir[i][0], col: dir[i][1])
                updateImage(list: puzzle?.table)
                break
            }
        }
        if let isFinish = isFinish, let timer = timer {
            if isFinish {
                timer.invalidate()
                getUserName()
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
            let secInt = String(format: "%02d", Int(self.count) % 60)
            let minsInt = String(format: "%02d", Int(self.count / 60) % 60)
            let hourInt = String(format: "%02d", Int(self.count / 3600) % 24)
            self.timeLabel.text = "\(hourInt):\(minsInt):\(secInt)"
        }
    }
    
    func getUserName() {
        let controller = UIAlertController(title: "恭喜", message: "請輸入你的稱呼", preferredStyle: .alert)
        controller.addTextField { (textField) in
            textField.placeholder = "名稱"
            textField.keyboardType = UIKeyboardType.alphabet
        }
        let okAction = UIAlertAction(title: "OK", style: .default) { (_) in
            let userName = controller.textFields?[0].text ?? ""
            DispatchQueue.main.async {
                self.performSegue(withIdentifier: "showResult", sender: userName)
            }
        }
        controller.addAction(okAction)
        let cancelAction = UIAlertAction(title: "取消", style: .cancel, handler: nil)
        controller.addAction(cancelAction)
        present(controller, animated: true, completion: nil)
    }
    
    func disablBtn(list: [Int]) {
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
                    puzzleImage[count].image = puzzle?.image[j]
                }
            }
        }
    }
    
    func cutImage() -> [UIImage] {
        var result: [UIImage] = [UIImage]()
        let originalImage = UIImage(named: "test")
        
        let oriHeight = Double(originalImage!.size.height)
        let oriWidth = Double(originalImage!.size.width)
        let max = oriHeight > oriWidth ? oriWidth : oriHeight
        let square = max / 3
        
        let oriCGImage = originalImage!.cgImage
        if let image = oriCGImage {
            for i in 0...2 {
                for j in 0...2 {
                    print("\(oriWidth - max + Double(j) * square)")
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
        puzzle = Puzzle(image: cutImage(), name: "hello")
        let seq = puzzle?.shuffle()
        if let seq = seq {
            var count = -1
            for i in seq {
                for j in i {
                    count += 1
                    if j == -1 {
                        continue
                    }
                    puzzleImage[count].image = puzzle!.image[j]
                }
            }
        }
        let tmp = puzzle?.updateBtn()
        disablBtn(list: tmp!)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let userName = sender as? String
        
        let now: Date = Date()
        let dateFormat: DateFormatter = DateFormatter()
        dateFormat.dateFormat = "yyyy/MM/dd HH:mm:ss"
        let curTime: String = dateFormat.string(from: now)
        
        let controller = segue.destination as? ScoreBoardViewController
        controller?.curRecord = record(score: self.count, time: curTime, name: userName)
    }
}
