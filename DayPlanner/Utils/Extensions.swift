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

extension UIColor {
    convenience init(hex: String, alpha: CGFloat = 1.0) {
        var hexFormatted: String = hex.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines).uppercased()

        if hexFormatted.hasPrefix("#") {
            hexFormatted = String(hexFormatted.dropFirst())
        }

        assert(hexFormatted.count == 6, "Invalid hex code used.")

        var rgbValue: UInt64 = 0
        Scanner(string: hexFormatted).scanHexInt64(&rgbValue)

        self.init(red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
                  green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
                  blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
                  alpha: alpha)
    }

    func toHexString() -> String {
        var r:CGFloat = 0
        var g:CGFloat = 0
        var b:CGFloat = 0
        var a:CGFloat = 0
        getRed(&r, green: &g, blue: &b, alpha: &a)
        let rgb:Int = (Int)(r*255)<<16 | (Int)(g*255)<<8 | (Int)(b*255)<<0

        return String(format:"#%06x", rgb)
    }
}
