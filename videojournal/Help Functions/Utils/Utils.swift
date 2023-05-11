//
//  Utils.swift
//  videojournal
//
//  Created by Tyler Thammavong on 5/02/23.
//

import UIKit

/*Utility functions used in the entire app*/
//Controller navigation switching to mainVc and initial onboarding screen
class Utils {
    
    static func switchToOnboarding() {
        if let rootViewController = UIStoryboard(name: "OnBoarding", bundle: nil).instantiateInitialViewController()  {
            let scenes = UIApplication.shared.connectedScenes.first as? UIWindowScene
            scenes?.windows.first?.rootViewController = rootViewController
        }
    }
    
    static func switchToMain() {
        if let rootViewController = UIStoryboard(name: "Main", bundle: nil).instantiateInitialViewController()  {
            let scenes = UIApplication.shared.connectedScenes.first as? UIWindowScene
            let tabbarController = scenes?.windows.first?.rootViewController as? UITabBarController
            scenes?.windows.first?.rootViewController = rootViewController
            tabbarController?.selectedIndex = 1
        }
    }
}
