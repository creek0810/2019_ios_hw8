//
//  gameViewController.swift
//  2019_ios_hw8
//
//  Created by 王心妤 on 2019/4/30.
//  Copyright © 2019年 river. All rights reserved.
//

import UIKit
import UserNotifications
import AudioToolbox
import AVFoundation


class GameViewController: UIViewController {
    
    var puzzle: Puzzle?
    var timer: Timer?
    var count: Int = 0
    var audioPlayer: AVAudioPlayer!

    
    @IBOutlet weak var titleItem: UINavigationItem!
    @IBOutlet weak var maskView: UIView!
    @IBOutlet var btnCollection: [UIButton]!
    @IBOutlet var puzzleImage: [UIImageView]!
    @IBOutlet var timeLabel: UILabel!
    @IBOutlet weak var finishImage: UIImageView!
    
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
                audioPlayer.pause()
                timer.invalidate()
                
                let defaultFinishPuzzle = [puzzle?.name ?? "": false]
                UserDefaults.standard.register(defaults: defaultFinishPuzzle)
                
                let haveFinish = UserDefaults.standard.bool(forKey: puzzle?.name ?? "")
                if haveFinish == false {
                    firstFinish()
                } else {
                    getUserName()
                }
                
            }else{
                let tmp = puzzle?.updateBtn()
                disablBtn(list: tmp!)
            }
        }
    }
    
    @IBAction func gameStart(_ sender: UIButton) {
        sender.isEnabled = false
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
    
    func firstFinish() {
        sendNotification()
        UserDefaults.standard.set(true, forKey: puzzle?.name ?? "")
        let token = puzzle?.name.components(separatedBy: " ")
        if let token = token {
            let ID = Int(token[1])!
            // establish finishImage
            self.finishImage.image = UIImage(named: "wallpaper\(ID)")
            self.finishImage.alpha = 0
            // play the clap soundtrack
            if let soundURL = Bundle.main.url(forResource: "win", withExtension: "wav") {
                var mySound: SystemSoundID = 0
                AudioServicesCreateSystemSoundID(soundURL as CFURL, &mySound)
                AudioServicesPlaySystemSound(mySound);
            }
            // show new wallpaper
            UIViewPropertyAnimator.runningPropertyAnimator(withDuration: 3, delay: 1, animations: {
                self.maskView.alpha = 1
                self.finishImage.alpha = 1
            }, completion: {(_) -> () in
                let tmpTimer: Timer?
                tmpTimer = Timer.scheduledTimer(withTimeInterval: 3, repeats: false, block: { (_) in
                    self.getUserName()
                })
            })
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
        titleItem.title = puzzle?.name
        print(puzzle?.name)
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
        // play background music
        
        let url = Bundle.main.url(forResource: "bgm", withExtension: "mp3")
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: url!)
            audioPlayer.numberOfLoops = -1

            audioPlayer.prepareToPlay()
        } catch {
            print("Error:", error.localizedDescription)
        }
        audioPlayer.play()
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
