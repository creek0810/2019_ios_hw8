//
//  ScoreBoardViewController.swift
//  2019_ios_hw8
//
//  Created by 王心妤 on 2019/5/3.
//  Copyright © 2019年 river. All rights reserved.
//

import UIKit

class ScoreBoardViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return scoreBoardData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell = UITableViewCell(style: .subtitle, reuseIdentifier: "Cell")
        if let name = scoreBoardData[indexPath.row].name, let score = scoreBoardData[indexPath.row].score, let time = scoreBoardData[indexPath.row].time {
            cell.textLabel!.text = "\(name) \(score) \(time)"
            return cell
        }
        return cell
    }
    
    
    var curRecord: record?
    var scoreBoardData: [record] = [record]()
    @IBOutlet weak var scoreBoardTable: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        scoreBoardTable.dataSource = self
        scoreBoardTable.delegate = self
        
        if let curRecord = curRecord {
            NetworkController.shared.postScore(newRecord: curRecord, completion: { (result: String) -> Void in
                print(result)
                
            })
        }
        
        
    
        if let curRecord = curRecord {
            NetworkController.shared.getScore(queryRecord: curRecord, completion: { (scoreBoard: [record]) -> Void in
                self.scoreBoardData = scoreBoard
                DispatchQueue.main.async {
                    self.scoreBoardTable.reloadData()
                }
            })
        }
        
        
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
