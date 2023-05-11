//
//  PhotoPreviewVC.swift
//  videojournal
//
//  Created by Tyler Thammavong on 5/03/23.
//

import UIKit

class PhotoPreviewVC: UIViewController, Storyboarded {
    // MARK: - IBOutlets
    @IBOutlet weak var photoIV: UIImageView!

    // MARK: - Class Properties
    var photo: UIImage!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        photoIV.image = photo
    }
}

// MARK: - IBActions
extension PhotoPreviewVC {
    @IBAction func clossButtonPressed(_ sender: UIButton) {
        self.dismiss(animated: true)
    }
}
