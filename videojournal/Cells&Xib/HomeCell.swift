//
//  HomeCell.swift
//  videojournal
//
//  Created by Tyler Thammavong on 4/06/2023
//

import UIKit

class HomeCell: UITableViewCell {
    // MARK: - IBOutlets
    @IBOutlet weak var bacvkgroundIV: UIImageView!
    @IBOutlet weak var profileIV: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var commentTF: UITextField!

    func updateCell(with item: [String: String]) {
        bacvkgroundIV.image = UIImage(named: item["coverPhoto"]!)
        profileIV.image = UIImage(named: item["profilePhoto"]!)
        nameLabel.text = item["name"]
        timeLabel.text = item["time"]
    }
}
