//
//  Extensions.swift
//  MemoAppPratice
//
//  Created by 석기권 on 6/18/24.
//

import UIKit

extension UITextField {
    func addBottomBorder(){
        let bottomLine = CALayer()
        bottomLine.frame = CGRect(x: 0, y: self.frame.size.height - 1, width: self.frame.size.width, height: 1)
        bottomLine.backgroundColor = UIColor.separator.cgColor
        borderStyle = .none
        layer.addSublayer(bottomLine)
    }
}
