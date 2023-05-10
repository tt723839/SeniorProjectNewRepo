//
//  ProfileVideoCell.swift
//  videojournal
//
//  Created by Tyler Thammavong 03/03/2023
//

import UIKit

class ProfileVideoCell: UICollectionViewCell {
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var thumbnailIV: UIImageView!
    @IBOutlet weak var topGradientView: UIView!

    override func layoutSubviews() {
        super.layoutSubviews()
        DispatchQueue.main.async {
            self.topGradientView.addGradient(startPoint: .topCenter, endPoint: .bottomCenter, colorArray: [.clear, .black.withAlphaComponent(0.4), .black.withAlphaComponent(0.2)])
        }
    }
}
