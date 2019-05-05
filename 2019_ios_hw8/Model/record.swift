//
//  Score.swift
//  2019_ios_hw8
//
//  Created by 王心妤 on 2019/5/3.
//  Copyright © 2019年 river. All rights reserved.
//

import Foundation

struct record: Codable {
    let score: Int?
    let costTime: String?
    let time: String?
    let name: String?
    
    static func ==(left: record, right: record) -> Bool {
        return
            left.score == right.score &&
            left.costTime == right.costTime &&
            left.time == right.time &&
            left.name == right.name 
    }
}
