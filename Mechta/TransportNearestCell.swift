//
//  TransportNearestCell.swift
//  Mechta
//
//  Created by Evgeniy Safronov on 18.02.17.
//
//

import UIKit

class TransportNearestCell: UITableViewCell {
    @IBOutlet var startTimeLabel: UILabel?
    @IBOutlet var separatorLabel: UILabel?
    @IBOutlet var endTimeLabel: UILabel?
    @IBOutlet var leftTimeLabel: UILabel?
    
    func show(_ item: NearestTransportItem) {
        startTimeLabel?.text = item.startTime
        endTimeLabel?.text = item.endTime
        leftTimeLabel?.text = "Через\n5 минут"
        separatorLabel?.textColor = UIColor.lightGray
        endTimeLabel?.textColor = UIColor.lightGray
    }

}
