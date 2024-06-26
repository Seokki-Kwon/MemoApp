//
//  Type.swift
//  MemoAppPratice
//
//  Created by 석기권 on 6/26/24.
//

import UIKit

enum ActionSheetType: CaseIterable {
    case delete
    
    var title: String {
        switch self {
        case .delete:
            "일정 삭제"
        }
    }
    
    var style: UIAlertAction.Style {
        switch self {
        case .delete:
            .destructive
        }
    }
}
