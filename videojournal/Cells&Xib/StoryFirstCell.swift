//
//  StoryFirstCell.swift
//  videojournal
//
//  Created by Tyler Thammavong on 5/04/23.
//

import UIKit

class StoryMainCell: UICollectionViewCell {
    // MARK: - IBOutlets
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var profileIV: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var userNameLabel: UILabel!

    func updateCell(with item: [String: String]) {
        imageView.image = UIImage(named: item["coverPhoto"]!)
        profileIV.image = UIImage(named: item["profilePhoto"]!)
        nameLabel.text = item["name"]
        userNameLabel.text = item["username"]
    }
}
