//
//  ScoreBoardViewController.swift
//  2019_ios_hw8
//
//  Created by 王心妤 on 2019/5/3.
//  Copyright © 2019年 river. All rights reserved.
//

import UIKit

class ScoreBoardViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    
    var curRecord: record?
    var globalScoreBoard: [record] = [record]()
    var personalScoreBoard: [record] = [record]()

    
    @IBOutlet weak var boardSwitch: UISegmentedControl!
    @IBOutlet weak var scoreBoardTable: UITableView!
    
    @IBAction func boardChanged(_ sender: Any) {
        self.scoreBoardTable.reloadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if boardSwitch.selectedSegmentIndex == 0{
            return personalScoreBoard.count
        } else {
            if globalScoreBoard.count == 0 {
                return 0
            }
            return globalScoreBoard.count - 1
        }
        
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ScoreBoardTableViewCell", for: indexPath) as! ScoreBoardTableViewCell
        if boardSwitch.selectedSegmentIndex == 0{
            cell.userName.text = personalScoreBoard[indexPath.row].name
            cell.costTime.text = personalScoreBoard[indexPath.row].costTime
            cell.rank.text = "\(indexPath.row + 1)"
            if personalScoreBoard[indexPath.row] == curRecord! {
                cell.backgroundColor = UIColor(red: 255 / 255, green: 247 / 255, blue: 180 / 255, alpha: 0.5)
            }else{
                cell.backgroundColor = UIColor(red: 255 / 255, green: 255 / 255, blue: 255 / 255, alpha: 0)
            }
        } else {
            cell.userName.text = globalScoreBoard[indexPath.row].name
            cell.costTime.text = globalScoreBoard[indexPath.row].costTime
            cell.rank.text = "\(indexPath.row + 1)"
            if indexPath.row == globalScoreBoard[globalScoreBoard.count - 1].score {
                cell.backgroundColor = UIColor(red: 255 / 255, green: 247 / 255, blue: 180 / 255, alpha: 0.5)
            }else{
                cell.backgroundColor = UIColor(red: 255 / 255, green: 255 / 255, blue: 255 / 255, alpha: 0)
            }
        }
        return cell
    }
    
    func updatePersonalScore() {
        let defaultPersonalScore = ["personalScore": [[String: Any]]()]
        UserDefaults.standard.register(defaults: defaultPersonalScore)
        
        if let personalScore = UserDefaults.standard.array(forKey: "personalScore") as? [[String: Any]] {
            var personalScoreCopy = personalScore
            personalScoreCopy.append([
                "costTime": curRecord?.costTime ?? "",
                "name": curRecord?.name ?? "",
                "time": curRecord?.time ?? "",
                "score": curRecord?.score ?? 0
                ])
            personalScoreCopy.sort { (score1, score2) -> Bool in
                let time1 = score1["time"] as! String
                let score1 = score1["score"] as! Int
                
                let time2 = score2["time"] as! String
                let score2 = score2["score"] as! Int
                
                if score1 == score2 {
                    return time1 < time2
                }
                return score1 < score2
            }
            print(personalScoreCopy)
            UserDefaults.standard.set(personalScoreCopy, forKey: "personalScore")
            for score in personalScoreCopy {
                personalScoreBoard.append(record(score: score["score"] as! Int, costTime: score["costTime"] as! String, time: score["time"] as! String, name: score["name"] as! String))
            }
            print(personalScoreBoard)
        }
    }
    
    func updateGlobalScore() -> Bool {
        if let curRecord = curRecord {
            NetworkController.shared.postScore(newRecord: curRecord, completion: { () -> Void in
                NetworkController.shared.getScore(queryRecord: curRecord, completion: { (scoreBoard: [record]) -> Void in
                    self.globalScoreBoard = scoreBoard
                    DispatchQueue.main.async {
                        self.scoreBoardTable.reloadData()
                    }
                })
            })
        }
        return true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        scoreBoardTable.dataSource = self
        scoreBoardTable.delegate = self
        scoreBoardTable.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        
        updatePersonalScore()
        updateGlobalScore()
        
        
        
       
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
