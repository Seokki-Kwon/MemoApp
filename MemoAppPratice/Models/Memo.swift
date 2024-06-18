//
//  Memo.swift
//  MemoAppPratice
//
//  Created by 석기권 on 6/17/24.
//

import Foundation
import UIKit

struct Memo {
    static var memoCount = 0
    let id: Int
    var title: String
    var content: String    
    
    init(id: Int, title: String, content: String) {        
        self.id = id
        self.title = title
        self.content = content
    }
}
