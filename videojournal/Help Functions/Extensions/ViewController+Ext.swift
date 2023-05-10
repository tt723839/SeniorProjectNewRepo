//
//  ViewController+Ext.swift
//  videojournal
//
//  Created by Tyler Thammavong 
//
//  Viewcontroller navigation

import UIKit
import AVFoundation
import SafariServices

extension UIViewController {
    
    func isNavigationHidden(with status: Bool, animated: Bool = false) {
        self.navigationController?.setNavigationBarHidden(status, animated: animated)
    }
    
    func isHideTabBar(status: Bool) {
        self.tabBarController?.tabBar.isHidden = status
    }
    
    func navBarTintColor(color: UIColor) {
        navigationController?.navigationBar.tintColor = color
    }
}

extension UIViewController {
    
    func addChildViewControllerWithView(_ childViewController: UIViewController, toView view: UIView? = nil) {
        let view: UIView = view ?? self.view
        
        childViewController.removeFromParent()
        childViewController.willMove(toParent: self)
        addChild(childViewController)
        view.addSubview(childViewController.view)
        childViewController.didMove(toParent: self)
        view.setNeedsLayout()
        view.layoutIfNeeded()
    }
    
    func removeChildViewController(_ childViewController: UIViewController) {
        childViewController.removeFromParent()
        childViewController.willMove(toParent: nil)
        childViewController.removeFromParent()
        childViewController.didMove(toParent: nil)
        childViewController.view.removeFromSuperview()
        view.setNeedsLayout()
        view.layoutIfNeeded()
    }
    
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    func showIndicator() {
        let onView = UIView()
        onView.tag = 3011594
        onView.frame = self.view.bounds
        onView.translatesAutoresizingMaskIntoConstraints = false
        onView.backgroundColor = UIColor.black.withAlphaComponent(0.2)
        self.view.addSubview(onView)
        
        
        onView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 0).isActive = true
        onView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: 0).isActive = true
        onView.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 0).isActive = true
        onView.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: 0).isActive = true
        
        let progressIV = UIImageView()
        progressIV.frame.size = CGSize(width: 50, height: 50)
        progressIV.center = self.view.center
        if  let gif = UIImage.gifImageWithName("progrss") {
            progressIV.image = gif
        }
        onView.addSubview(progressIV)
    }
    
    func hideIndicator() {
        guard let dismissView = self.view.viewWithTag(3011594) else {
            debugPrint("Dismiss View not found..")
            return
        }
        dismissView.removeFromSuperview()
    }
}
