//
//  CustomSegmentedControl.swift
//  MemoAppPratice
//
//  Created by 석기권 on 6/26/24.
//

import UIKit

final class CustomSegmentedControl: UISegmentedControl {
        private var cornerRadius: CGFloat = 15

        override func layoutSubviews() {
            super.layoutSubviews()
            layer.cornerRadius = cornerRadius
    
            guard let selectedSegment = subviews[numberOfSegments] as? UIImageView else {
                return
            }
            
            selectedSegment.image = nil            
            selectedSegment.backgroundColor = selectedSegmentTintColor
            selectedSegment.layer.removeAnimation(forKey: "SelectionBounds")
            selectedSegment.layer.cornerRadius = cornerRadius - layer.borderWidth
            selectedSegment.bounds = CGRect(origin: .zero, size: CGSize(
                width: selectedSegment.bounds.width,
                height: bounds.height - layer.borderWidth * 2
            ))
        }
    }
