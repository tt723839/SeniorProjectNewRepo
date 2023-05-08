// Tyler Thammavong
// 02/04/2023

import UIKit
import AVKit

class ProfileVC: UIViewController {
    @IBOutlet weak var coverBackView: UIView!
    @IBOutlet weak var coverIV: UIImageView!
    @IBOutlet weak var profileIV: UIImageView!
    @IBOutlet weak var coverShadowView: UIView!
    @IBOutlet weak var collectionView: UICollectionView!
    
    // Class Properties
    var imagePickerManager: MTImagePickerManager!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initialSetup()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        DispatchQueue.main.async {
            self.coverShadowView.addGradient(startPoint: .topCenter, endPoint: .bottomCenter, colorArray: [.clear, .black])
        }
    }
}

// Class Methods
extension ProfileVC {
    fileprivate func initialSetup() {
        
        coverBackView.roundCorners(corners: [.bottomLeft, .bottomRight], radius: 35)
        
        collectionView.register(cellType: ProfileVideoCell.self)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.collectionViewLayout = CustomCollectionViewLayout()
        collectionView.contentInset.bottom = 130
        
        if let layout = collectionView?.collectionViewLayout as? CustomCollectionViewLayout {
            layout.delegate = self
        }
        
        DispatchQueue.main.async {
            self.configImagePickerManager()
        }
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(didTapOnSelectCoverPhoto))
        coverIV.addGestureRecognizer(tapGesture)
        coverIV.isUserInteractionEnabled = true
    }
    
    fileprivate func configImagePickerManager() {
        var config = MTImagePickerManagerConfiguration()
        config.mediaType = .photo
        config.allowEditing = false
        imagePickerManager = MTImagePickerManager(configuration: config, on: self)
    }
    
    fileprivate func selectPhoto(with imageView: UIImageView) {
        imagePickerManager.didFinishSelection(pickFrom: .both) {(selectedImage) in
            
            if case .photo(let photo) = selectedImage {
                imageView.image = photo.image
            }
        }
    }
    
    fileprivate func playVideo() {
        let videoURL = URL(string: "http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerEscapes.mp4")
        let player = AVPlayer(url: videoURL!)
        let playerViewController = AVPlayerViewController()
        playerViewController.player = player
        self.present(playerViewController, animated: true) {
            playerViewController.player!.play()
        }
    }
}

// Actions
extension ProfileVC {
    @IBAction func selectProfilePhotoButtonPressed(_ sender: UIButton) {
        selectPhoto(with: profileIV)
    }
    
    @objc func didTapOnSelectCoverPhoto() {
        selectPhoto(with: coverIV)
    }
}

// UICollectionViewDataSource
extension ProfileVC: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(with: ProfileVideoCell.self, for: indexPath)
        return cell
    }
}

// UICollectionViewDelegate & UICollectionViewDelegateFlowLayout
extension ProfileVC: UICollectionViewDelegate, CustomCollectionViewLayoutDelegate {
    func collectionView(_ collectionView: UICollectionView, heightForPhotoAtIndexPath indexPath: IndexPath) -> CGFloat {
        return indexPath.item % 2 == 0 ? 247 : 184
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        playVideo()
    }
}

