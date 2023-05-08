//
//  MTImagePickerManager.swift
//  videojournal
//
//  Created by Tyler Thammavong
//

import UIKit
import MobileCoreServices
import AVFoundation

public struct MTImagePickerManagerConfiguration {
    public init() {}

    /// Select the media type in library default is photo
    var mediaType = MTMediaType.photo
    
    /// Max video duration default is 10
    var videoMaximumDuration: TimeInterval = 10
    var allowEditing: Bool = false
   
}

public struct MTMediaPhoto {
    var imageURL: URL
    var absoluteStringURL: String
    var image: UIImage
}

public struct MTMediaVideo {
    var videoURL: URL
    var absoluteStringURL: String
    var thumbnail: UIImage
}

enum MTMediaPicker {
    case photo(photo: MTMediaPhoto)
    case video(video: MTMediaVideo)
}

enum MTTakeImageFrom {
    case camera
    case gallery
    case both
}

//MARK: - Media Type
enum MTMediaType: String {
    case photo
    case video
    case photoAndVideo
    
    var value: [String] {
        
        switch self {
        case .photo:
            return ["public.image"]
        case .video:
            return ["public.movie"]
        default:
            return ["public.image", "public.movie"]
        }
    }
}

class MTImagePickerManager: NSObject {
    
    private let imagePicker: UIImagePickerController
    private weak var presentationController: UIViewController?
    private var configuration: MTImagePickerManagerConfiguration?
    
    var didFinishSelection: ((MTMediaPicker)-> Void)?
    
    public required init(configuration: MTImagePickerManagerConfiguration, on: UIViewController) {
        self.imagePicker = UIImagePickerController()

        super.init()
        
        self.configuration = configuration
        self.presentationController = on

        imagePicker.delegate = self
        imagePicker.allowsEditing = configuration.allowEditing
        self.imagePicker.mediaTypes = configuration.mediaType.value
        self.imagePicker.videoMaximumDuration = configuration.videoMaximumDuration
    }
    
    func didFinishSelection(pickFrom: MTTakeImageFrom = .both, completion: @escaping (MTMediaPicker)-> Void) {
        
        //Call back
        self.didFinishSelection = completion
        
        AVCaptureDevice.requestAccess(for: .video) { success in
            
            if success {
                
                DispatchQueue.main.async {
                    
                    switch pickFrom {
                    case .camera:
                        self.openGallaryOrCamera(sourceType: .camera)
                    case .gallery:
                        self.openGallaryOrCamera(sourceType: .photoLibrary)
                    case .both:
                        self.takeImage()
                    }
                }
            } else {
                Services.showErrorAlert(with: "camara permission is required to use this feature")
            }
        }
    }
    
    private func takeImage(){
        
        let cameraAction = UIAlertAction(title: "Camera", style: UIAlertAction.Style.default) { UIAlertAction in
            self.openGallaryOrCamera(sourceType: .camera)
        }
        
        let gallaryAction = UIAlertAction(title: "Gallery", style: UIAlertAction.Style.default) { UIAlertAction in
            self.openGallaryOrCamera(sourceType: .photoLibrary)
        }
        
        let cancelActionButton = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        Services.showAlert(style: .actionSheet, title: "choose option", message: nil, actions: [cameraAction, gallaryAction, cancelActionButton], completion: nil)
    }
    
    private func openGallaryOrCamera(sourceType: UIImagePickerController.SourceType) {

        guard (UIImagePickerController.isSourceTypeAvailable(sourceType)) else {
            Services.showErrorAlert(with: "Camera not Available")
            return
        }
        
        imagePicker.sourceType = sourceType

        presentationController?.present(imagePicker, animated: true, completion: nil)
    }
    
    private func selectedImage(imageURL: URL, picker: UIImagePickerController) {
        let photo = MTMediaPhoto(imageURL: imageURL, absoluteStringURL: imageURL.absoluteString, image: setImageFromLocalURL(imageURL: imageURL))
        
        picker.dismiss(animated: true) {
            self.didFinishSelection?(MTMediaPicker.photo(photo: photo))
        }
    }
    
    private func selectedVideo(videoURL: URL, picker: UIImagePickerController) {

        if let videoURl = Services.copyVideoAndGetUrl(videoUrl: videoURL) {
            AVAsset(url: URL(string: videoURl.absoluteString)!).generateThumbnail { [weak self] (image) in
                DispatchQueue.main.async {
                    guard let image = image else { return }
                    
                    let video = MTMediaVideo(videoURL: videoURl, absoluteStringURL: videoURl.absoluteString, thumbnail: image)
                    self?.didFinishSelection?(MTMediaPicker.video(video: video))
                }
            }
        } else {
            Services.showAlert(style: .alert, title: "", message: "Error while Picking video")
        }
        
        print("Video Picked")
        picker.dismiss(animated: true, completion: nil)
    }
    
    func setImageFromLocalURL(imageURL: URL) -> UIImage {
        
        guard let data = try? Data(contentsOf: imageURL) else {return UIImage()}
        return UIImage(data: data) ?? UIImage()
    }
    
    private func saveImageAndGetUrl(image: UIImage, imageName: String = "")-> URL? {
        
        let directoryUrl = URL(fileURLWithPath: NSTemporaryDirectory(), isDirectory: true)

        let fileName = UUID().uuidString
        let fileURL = directoryUrl.appendingPathComponent("\(fileName).jpeg")
        guard let data = image.jpegData(compressionQuality: 0.2) else { return nil }
        
        do {
            try data.write(to: fileURL)
            return fileURL
            
        } catch let error {
            print("error saving file with error", error)
            return nil
        }
    }
}

//MARK: - UIImagePickerControllerDelegate
extension MTImagePickerManager : UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    public func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]){
        
        //Pick Image from Gallary
//        if let imageURL = info[.imageURL] as? URL {
//
//            self.selectedImage(imageURL: imageURL, picker: picker)
//            return
//        }
        
        //Capture image from Camera
        if let image = info[.editedImage] as? UIImage {
            
            if let imageURL = saveImageAndGetUrl(image: image) {
                
                self.selectedImage(imageURL: imageURL, picker: picker)
            } else {
                Services.showAlert(style: .alert, title: "", message: "Error while saving image")
            }
            
            print("Capture Image Picked")
            picker.dismiss(animated: true, completion: nil)
            return
        }
        
        if let image = info[.originalImage] as? UIImage {
            
            if let imageURL = saveImageAndGetUrl(image: image) {
                
                self.selectedImage(imageURL: imageURL, picker: picker)
            } else {
                Services.showAlert(style: .alert, title: "", message: "Error while saving image")
            }
            
            print("Capture Image Picked")
            picker.dismiss(animated: true, completion: nil)
            return
        }
        
        //Picked Video
        if let mediaType = info[.mediaURL] as? URL {
            self.selectedVideo(videoURL: mediaType, picker: picker)
        }
    }
    
    //MARK: - Add image to Library
//    func image(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
//        // we got back an error!
//
//        Services.showErrorAlert(with: error!.localizedDescription)
//    }
    
    public func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}
