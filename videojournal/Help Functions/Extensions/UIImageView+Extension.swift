//
//  UIImageView+Extension.swift
//  PhotoEdit
//
//  Created by Tyler Thammavong 
//

import UIKit
import Photos

extension UIImageView {
  func fetchImageAsset(_ asset: PHAsset?, targetSize size: CGSize, contentMode: PHImageContentMode = .aspectFill, options: PHImageRequestOptions? = nil, completionHandler: ((Bool) -> Void)?) {

    guard let asset = asset else {
      completionHandler?(false)
      return
    }

    let resultHandler: (UIImage?, [AnyHashable: Any]?) -> Void = { image, info in
      self.image = image
      completionHandler?(true)
    }

    PHImageManager.default().requestImage(
      for: asset,
      targetSize: size,
      contentMode: contentMode,
      options: options,
      resultHandler: resultHandler)
  }
}
