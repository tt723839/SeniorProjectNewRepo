//
//  HomeVC.swift
//  videojournal
//
//  Created by Tyler Thammavong 3/27/2023
//

import UIKit

class HomeVC: UIViewController {
    // MARK: - IBOutlets
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var tableView: UITableView!

    // MARK: - Class Properties
    let stories: [[String: String]] = [
        [:],
        [
            "name": "Nelk",
            "username": "nelk",
            "coverPhoto": "storyMaindemo",
            "profilePhoto": "demoLogo"
        ],
        [
            "name": "iJustine",
            "username": "ijustine",
            "coverPhoto": "storyMaindemo2",
            "profilePhoto": "demoLogo2"
        ],
        [
            "name": "Chainsmokers",
            "username": "thechainsmokers",
            "coverPhoto": "storyMaindemo3",
            "profilePhoto": "demoLogo3"
        ]
    ]
    
    let posts: [[String: String]] = [
        [
            "name": "Kaitlyn Wills",
            "time": "2 minutes ago",
            "coverPhoto": "demoTableView",
            "profilePhoto": "storyMaindemo"
        ],
        [
            "name": "Mike Allison",
            "time": "15 minutes ago",
            "coverPhoto": "demoTableView2",
            "profilePhoto": "storyMaindemo2"
        ],
        [
            "name": "Steve Martin",
            "time": "3 minutes ago",
            "coverPhoto": "demoTableView3",
            "profilePhoto": "storyMaindemo3"
        ],
        [
            "name": "Kaitlyn Wills",
            "time": "2 minutes ago",
            "coverPhoto": "demoTableView4",
            "profilePhoto": "storyMaindemo"
        ],
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initialSetup()
    }
}

// MARK: - Class Methods
extension HomeVC {
    fileprivate func initialSetup() {
        self.searchBar.searchTextField.borderStyle = .none
        self.searchBar.searchTextField.layer.cornerRadius = 17
        self.searchBar.searchTextField.backgroundColor = .black
        self.searchBar.searchTextField.leftView?.tintColor = UIColor("0x9999A2")

        collectionView.register(cellType: StoryFirstCell.self)
        collectionView.register(cellType: StoryMainCell.self)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.contentInset = .init(top: 0, left: 25, bottom: 0, right: 25)
        
        tableView.contentInset = .init(top: 0, left: 0, bottom: 20, right: 0)
    }
}

// MARK: - UICollectionViewDataSource
extension HomeVC: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return stories.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.row == 0 {
            let cell = collectionView.dequeueReusableCell(with: StoryFirstCell.self, for: indexPath)
            return cell
        }
        
        let cell = collectionView.dequeueReusableCell(with: StoryMainCell.self, for: indexPath)
        cell.updateCell(with: stories[indexPath.row])
        return cell
    }
}

// MARK: - UICollectionViewDelegate & UICollectionViewDelegateFlowLayout
extension HomeVC: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return .init(width: 90, height: 120)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
}

// MARK: - UITableViewDataSource
extension HomeVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(with: HomeCell.self, for: indexPath)
        cell.updateCell(with: posts[indexPath.row])
        return cell
    }
}

// MARK: - UITableViewDelegate
extension HomeVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 261
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
}

