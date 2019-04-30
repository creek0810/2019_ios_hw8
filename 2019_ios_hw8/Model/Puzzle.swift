//
//  Puzzle.swift
//  2019_ios_hw8
//
//  Created by 王心妤 on 2019/4/29.
//  Copyright © 2019年 river. All rights reserved.
//

import UIKit
import Foundation

struct loc {
    var row: Int
    var col: Int
}

struct Puzzle {
    var image: [UIImage]
    var name: String
    var whiteLoc: loc = loc(row: 2, col: 2)
    var table: [[Int]] = [[0, 1, 2], [3, 4, 5], [6, 7, -1]]
    
    init(image: [UIImage], name: String) {
        self.image = image
        self.name = name
    }
    
    mutating func move(row: Int, col: Int) -> Bool {
        table[whiteLoc.row][whiteLoc.col] = table[whiteLoc.row + row][whiteLoc.col + col]
        table[whiteLoc.row + row][whiteLoc.col + col] = -1
        self.whiteLoc.col += col
        self.whiteLoc.row += row
        return check()
    }
    
    
    mutating func shuffle() -> [[Int]]{
        let dir = [[0, 1], [0, -1], [1, 0], [-1, 0]]
        var preLoc: loc = loc(row: 2, col: 2)
        var success = 0
        while success < 20 {
            let tmpDir = dir.randomElement()!
            let tmpLoc = loc(row: whiteLoc.row + tmpDir[0], col: whiteLoc.col + tmpDir[1])
            if tmpLoc.row >= 0, tmpLoc.row <= 2, tmpLoc.col >= 0, tmpLoc.col <= 2, (tmpLoc.row != preLoc.row || tmpLoc.col != preLoc.col) {
                preLoc = whiteLoc
                let tmp = table[tmpLoc.row][tmpLoc.col]
                table[tmpLoc.row][tmpLoc.col] = -1
                table[whiteLoc.row][whiteLoc.col] = tmp
                whiteLoc = tmpLoc
                success += 1
            }
        }
        return table
    }
    func updateBtn() -> [Int]{
        var canNotPressed: [Int] = [Int]()
        if whiteLoc.row == 2 {
            canNotPressed.append(0)
        }
        if whiteLoc.row == 0 {
            canNotPressed.append(1)
        }
        if whiteLoc.col == 2 {
            canNotPressed.append(2)
        }
        if whiteLoc.col == 0 {
            canNotPressed.append(3)
        }
        return canNotPressed
    }
    
    func check() -> Bool{
        var count = 0
        for i in self.table {
            for j in i {
                if count == 8 {
                    return true
                }else if count != j {
                    return false
                }
                count += 1
            }
        }
        return true
    }
}
