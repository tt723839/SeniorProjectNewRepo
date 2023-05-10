//
//  Services.swift
//  videojournal
//
//  Created by Tyler Thammavong 03/02/2023
//

//image selector and video url processing functions in this file
//navigation of tab bar in file as well

import UIKit
import AVFoundation

//import SDWebImage


//navigation for VC

extension UIViewController {
    
    func topMostViewController() -> UIViewController {
        
        if let presented = self.presentedViewController {
            return presented.topMostViewController()
        }
        
        if let navigation = self as? UINavigationController {
            return navigation.visibleViewController?.topMostViewController() ?? navigation
        }
        
        if let tab = self as? UITabBarController {
            return tab.selectedViewController?.topMostViewController() ?? tab
        }
        
        return self
    }
}

extension UIWindow {
    static var key: UIWindow? {
        if #available(iOS 13, *) {
            let scenes = UIApplication.shared.connectedScenes.first as! UIWindowScene

            return scenes.keyWindow
        } else {
            return UIApplication.shared.keyWindow
        }
    }
}

extension UIApplication {
    func topMostViewController() -> UIViewController? {
        return UIWindow.key?.rootViewController?.topMostViewController()
    }
}

class Services {
    
    static var rootViewController: UIViewController? {
        return UIApplication.shared.topMostViewController()
    }
    
    static func showAlert(on: UIViewController? = nil,style: UIAlertController.Style, title: String?, message: String?, actions: [UIAlertAction] = [UIAlertAction(title: "Ok", style: .default, handler: nil)], completion: (() -> Swift.Void)? = nil) {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: style)
        for action in actions {
            alert.addAction(action)
        }
        
        DispatchQueue.main.async {
            if let vc = on {
                vc.present(alert, animated: true, completion: completion)
                return
            }
            rootViewController?.present(alert, animated: true, completion: completion)
        }
    }
    
    static func showErrorAlert(on: UIViewController? = nil, with message: String) {
        showAlert(on: on, style: .alert, title: "Error", message: message)
    }
}

// Image Picker
extension Services {
//    static func setImage(imageView: UIImageView, imageUrl: String?, placeholder imageName: String) {
//
//        if imageUrl == nil {
//            imageView.image = UIImage(named: imageName)
//            return
//        }
//
//        guard let  URL = URL(string: imageUrl!) else {
//            imageView.image = UIImage(named: imageName)
//            return
//        }
//
//        imageView.sd_imageIndicator = SDWebImageActivityIndicator.grayLarge
//        imageView.sd_setImage(with: URL, placeholderImage: UIImage(named: imageName), options: .scaleDownLargeImages, completed: nil)
//    }

    static func copyVideoAndGetUrl(videoUrl: URL) -> URL? {

        guard let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return nil }
        let fileURL = documentsDirectory.appendingPathComponent("copy.mov")

        guard let data = try? Data(contentsOf: videoUrl) else { return nil }

        //Checks if file exists, removes it if so.
        if FileManager.default.fileExists(atPath: fileURL.path) {
            do {
                try FileManager.default.removeItem(atPath: fileURL.path)
                print("Removed old image")
            } catch let removeError {
                print("couldn't remove file at path", removeError)
                return nil
            }
        }

        do {
            try data.write(to: fileURL)
            return fileURL

        } catch let error {
            print("error saving file with error", error)
            return nil
        }
    }

}
