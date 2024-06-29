//
//  CalendarCell.swift
//  DayPlanner
//
//  Created by 석기권 on 6/28/24.
//

import UIKit

class CalendarCell: UICollectionViewCell {
    static let reuseIdentifier = "calCell"
    @IBOutlet weak var dayOfMonth: UILabel!
    @IBOutlet weak var colorView: UIView!
}
