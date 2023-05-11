//
//  Utils+AllControllers.swift
//  videojournal
//
//  Created by Tyler Thammavong on 5/02/23.
//

import UIKit

extension UIViewController{
    // MARK: -------> Main <---------
    func loadPhotoPreviewVC(with photo: UIImage) {
        let vc: PhotoPreviewVC = PhotoPreviewVC.instantiate(storyboard: .main)
        vc.modalPresentationStyle = .fullScreen
        vc.modalTransitionStyle = .crossDissolve
        vc.photo = photo
        self.present(vc, animated: true)
    }
}
