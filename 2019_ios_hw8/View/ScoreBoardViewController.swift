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
    var scoreBoardData: [record] = [record]()
    
    let backgroundViewWhite = UIView()
    let backgroundViewRed = UIView()

    
    @IBOutlet weak var scoreBoardTable: UITableView!
    
    @IBAction func shareScore(_ sender: Any) {
        /*if let image = resultImage.image{
            let activityViewController = UIActivityViewController(activityItems: [image], applicationActivities: nil)
            self.present(activityViewController, animated: true, completion: nil)
        }*/
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if scoreBoardData.count == 0 {
            return 0
        }
        return scoreBoardData.count - 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ScoreBoardTableViewCell", for: indexPath) as! ScoreBoardTableViewCell
        cell.userName.text = scoreBoardData[indexPath.row].name
        cell.costTime.text = scoreBoardData[indexPath.row].costTime
        cell.rank.text = "\(indexPath.row + 1)"
        if indexPath.row == scoreBoardData[scoreBoardData.count - 1].score {
            cell.backgroundColor = UIColor.red
            cell.selectedBackgroundView = backgroundViewRed
        }else{
            cell.backgroundColor = UIColor.white
            cell.selectedBackgroundView = backgroundViewWhite
        }
        
        return cell
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        scoreBoardTable.dataSource = self
        scoreBoardTable.delegate = self
        scoreBoardTable.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        
        backgroundViewRed.backgroundColor = UIColor.red
        backgroundViewWhite.backgroundColor = UIColor.white
        
        if let curRecord = curRecord {
            NetworkController.shared.postScore(newRecord: curRecord, completion: { () -> Void in
                NetworkController.shared.getScore(queryRecord: curRecord, completion: { (scoreBoard: [record]) -> Void in
                    self.scoreBoardData = scoreBoard
                    DispatchQueue.main.async {
                        self.scoreBoardTable.reloadData()
                    }
                })
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
