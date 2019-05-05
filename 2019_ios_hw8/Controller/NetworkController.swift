//
//  NetworkController.swift
//  2019_ios_final_project
//
//  Created by User11 on 2019/4/24.
//  Copyright © 2019 ACL. All rights reserved.
//

import Foundation

struct NetworkController {
    
    static let shared = NetworkController()
    
    struct API {
        static let getScore = "http://140.121.197.197:6771/get_score"
        static let postScore = "http://140.121.197.197:6771/post_score"
    }
    
    func getScore(queryRecord: record, completion: @escaping ([record]) -> Void) {
        print("Start get")
        let urlStr = "\(API.getScore)?name=\(queryRecord.name ?? "")&score=\(queryRecord.score ?? 0)&time=\(queryRecord.time ?? "")&costTime=\(queryRecord.costTime ?? "")".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        if let url = URL(string: urlStr!){
            let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
                if let data = data, let scoreBoard = try? JSONDecoder().decode([record].self, from: data) {
                    completion(scoreBoard)
                }
            }
            task.resume()
        }
    }
    
    func postScore(newRecord: record, completion: @escaping () -> Void) {
        if let url = URL(string: API.postScore) {
            var request = URLRequest(url: url)
            
            let jsonData = try? JSONEncoder().encode(newRecord)
            request.httpMethod = "POST"
            request.httpBody = jsonData
            request.addValue("application/json", forHTTPHeaderField: "content-type")
            let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
                completion()
            }
            task.resume()
        }
    }
    
}
