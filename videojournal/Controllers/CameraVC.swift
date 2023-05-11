//
//  CameraVC.swift
//  videojournal
//
//  Created by Tyler Thammavong on 5/03/23.
//

import UIKit
import AVFoundation

class CameraVC: UIViewController {
    // MARK:
    @IBOutlet weak var buttonsStackView: UIStackView!
    
    // MARK: - Class Properties
    var captureSession: AVCaptureSession!
    var capturePhotoOutput: AVCapturePhotoOutput!
    var previewLayer = AVCaptureVideoPreviewLayer()
    var backCamera: AVCaptureDevice!
    var frontCamera: AVCaptureDevice!
    var backInput: AVCaptureInput!
    var frontInput: AVCaptureInput!
    var backCameraOn = true
    var flashMode: AVCaptureDevice.FlashMode = .off

    override func viewDidLoad() {
        super.viewDidLoad()
        initialSetup()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        previewLayer.frame = view.bounds
    }
}

// MARK: - Class Methods
extension CameraVC {
    fileprivate func initialSetup() {
        checkPermissions()
    }
    
    func checkPermissions() {
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .video) { [weak self] granted in
                guard granted else {
                    return
                }
                
                DispatchQueue.main.async {
                    self?.setupAndStartCaptureSession()
                }
            }
        case .restricted:
            break
        case .denied:
            break
        case .authorized:
            self.setupAndStartCaptureSession()
        @unknown default:
            break
        }
    }
    
    func setupPreviewLayer(){
        previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        previewLayer.videoGravity = .resizeAspectFill
        view.layer.insertSublayer(previewLayer, below: buttonsStackView.layer)
        previewLayer.frame = self.view.layer.frame
    }
    
    func setupAndStartCaptureSession() {
        DispatchQueue.global(qos: .userInitiated).async {
            
            //init session
            self.captureSession = AVCaptureSession()
            //start configuration
            self.captureSession.beginConfiguration()
            
            //session specific configuration
            if self.captureSession.canSetSessionPreset(.photo) {
                self.captureSession.sessionPreset = .photo
            }
            self.captureSession.automaticallyConfiguresCaptureDeviceForWideColor = true
            
            self.setupCameraInputs()
            
//            if self.captureSession.canAddOutput(self.capturePhotoOutput) {
//                self.captureSession.addOutput(self.capturePhotoOutput)
//            }
            
            DispatchQueue.main.async {
                self.setupPreviewLayer()
            }
            
            self.setupCameraOutput()
            //commit configuration
            self.captureSession.commitConfiguration()
            
            //start running it
            self.captureSession.startRunning()
            
        }
    }
    
    fileprivate func setupCameraInputs() {
        // get back camera
        if let backCamera = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .back) {
            self.backCamera = backCamera
        }
        
        // get front camera
        if let frontCamera = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .front) {
            self.frontCamera = frontCamera
        }
        
        do {
            self.backInput = try AVCaptureDeviceInput(device: backCamera)
            self.frontInput = try AVCaptureDeviceInput(device: frontCamera)
            
            // connect back camera to session
            if self.captureSession.canAddInput(backInput) {
                self.captureSession.addInput(backInput)
            }
            
        } catch {
            Services.showErrorAlert(with: error.localizedDescription)
        }
    }
    
    fileprivate func setupCameraOutput() {
        capturePhotoOutput = AVCapturePhotoOutput()
        
        if captureSession.canAddOutput(capturePhotoOutput) {
            captureSession.addOutput(capturePhotoOutput)
        }
    }
    
    fileprivate func switchCamera() {
        //reconfigure the input
        captureSession.beginConfiguration()
        if backCameraOn {
            captureSession.removeInput(backInput)
            captureSession.addInput(frontInput)
            backCameraOn = false
        } else {
            captureSession.removeInput(frontInput)
            captureSession.addInput(backInput)
            backCameraOn = true
        }
        
        //deal with the connection again for portrait mode
        capturePhotoOutput.connections.first?.videoOrientation = .portrait
        
        //mirror the video stream for front camera
        capturePhotoOutput.connections.first?.isVideoMirrored = !backCameraOn

        //commit config
        captureSession.commitConfiguration()
    }
}

// MARK: - IBActions
extension CameraVC {
    @IBAction func capturePhotoButtonPressed(_ sender: UIButton) {
        let settings = AVCapturePhotoSettings()
        settings.flashMode = flashMode
        capturePhotoOutput.capturePhoto(with: settings, delegate: self)
    }
    
    @IBAction func toggleFlashButtonPressed(_ sender: UIButton) {
        if !backCameraOn {
            return
        }
        
        sender.isSelected.toggle()
        flashMode = flashMode == .on ? .off : .on
    }
    
    @IBAction func flipCameraButtonPressed(_ sender: UIButton) {
        switchCamera()
    }
}

extension CameraVC: AVCapturePhotoCaptureDelegate {
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        guard let data = photo.fileDataRepresentation() else {
            return
        }
        
        guard let image = UIImage(data: data) else {
            return
        }
        loadPhotoPreviewVC(with: image)
    }
}
