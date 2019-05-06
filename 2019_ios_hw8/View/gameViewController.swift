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
    
    @IBAction func returnMenu(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
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
                
                let defaultFinishPuzzle = [puzzle?.name ?? "": false]
                UserDefaults.standard.register(defaults: defaultFinishPuzzle)
                
                let haveFinish = UserDefaults.standard.bool(forKey: puzzle?.name ?? "")
                if haveFinish == false {
                    print("new finish")
                    sendNotification()
                    UserDefaults.standard.set(true, forKey: puzzle?.name ?? "")
                }
                getUserName()
            }else{
                let tmp = puzzle?.updateBtn()
                disablBtn(list: tmp!)
            }
        }
    }
    
    @IBAction func gameStart(_ sender: Any) {
        let disableList = puzzle?.updateBtn()
        disablBtn(list: disableList!)
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { (_) in
            self.count += 1
            let secInt = String(format: "%02d", Int(self.count) % 60)
            let minsInt = String(format: "%02d", Int(self.count / 60) % 60)
            let hourInt = String(format: "%02d", Int(self.count / 3600) % 24)
            self.timeLabel.text = "\(hourInt):\(minsInt):\(secInt)"
        }
    }
    
    func sendNotification() {
        
        let content = UNMutableNotificationContent()
        content.title = "解鎖桌布"
        content.subtitle = "角落生物拼圖樂"
        content.body = "恭喜你完成了\(puzzle?.name ?? "")拼圖挑戰，快試試在桌布頁面下載可愛的角落生物桌布吧"
        content.badge = 1
        content.sound = UNNotificationSound.default
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
        
        let request = UNNotificationRequest(identifier: "notification", content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request, withCompletionHandler: {error in
            print("成功建立通知...")
        })
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
    
    func updateUI() {
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
        disablBtn(list: [0, 1, 2, 3])
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateUI()
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let userName = sender as? String
        
        let now: Date = Date()
        let dateFormat: DateFormatter = DateFormatter()
        dateFormat.dateFormat = "yyyy/MM/dd HH:mm:ss"
        let curTime: String = dateFormat.string(from: now)
        
        let controller = segue.destination as? ScoreBoardViewController
        controller?.curRecord = record(score: self.count, costTime: timeLabel.text, time: curTime, name: userName)
    }
}
