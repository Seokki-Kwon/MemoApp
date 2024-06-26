//
//  Extensions.swift
//  MemoAppPratice
//
//  Created by 석기권 on 6/18/24.
//

import UIKit
import RxSwift

extension UITextField {
    func addBottomBorder(){
        let bottomLine = CALayer()
        bottomLine.frame = CGRect(x: 0, y: self.frame.size.height - 1, width: self.frame.size.width, height: 1)
        bottomLine.backgroundColor = UIColor.separator.cgColor
        borderStyle = .none
        layer.addSublayer(bottomLine)
    }
}

extension Date {
    var toDateString: String? {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy.MM.dd"
        let dateString = formatter.string(from: self)
        return dateString
    }
}

extension UIViewController {
    func presentActionSheet<T: Sequence>(actionType: T, inputSubject: PublishSubject<T.Element>) where T.Element == ActionSheetType {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        for action in actionType {
            let alertAction = UIAlertAction(title: action.title, style: action.style) { _ in
                inputSubject.onNext(action)
            }
            alert.addAction(alertAction)
        }
        
        let cancle = UIAlertAction(title: "취소", style: .cancel)
        alert.addAction(cancle)
        present(alert, animated: true)
    }
}
