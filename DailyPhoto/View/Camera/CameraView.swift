//
//  CameraView.swift
//  DailyPhoto
//
//  Created by 伊藤璃乃 on 2025/01/03.
//

import SwiftUI
import AVFoundation

struct CameraView: UIViewControllerRepresentable {
    class Coordinator: NSObject, AVCapturePhotoCaptureDelegate {
        var parent: CameraView

        init(parent: CameraView) {
            self.parent = parent
        }

        func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
            guard let data = photo.fileDataRepresentation(),
                  let image = UIImage(data: data) else { return }
            DispatchQueue.main.async {
                self.parent.capturedImage = image
                self.parent.showPreview = false
            }
        }
    }

    @Binding var takePhoto: Bool
    @Binding var capturedImage: UIImage?
    @Binding var showPreview: Bool
    @Binding var flashEnabled: Bool

    func makeCoordinator() -> Coordinator {
        Coordinator(parent: self)
    }

    func makeUIViewController(context: Context) -> CameraViewController {
        let cameraViewController = CameraViewController()
        cameraViewController.coordinator = context.coordinator
        cameraViewController.flashEnabled = flashEnabled
        return cameraViewController
    }

    func updateUIViewController(_ uiViewController: CameraViewController, context: Context) {
        uiViewController.flashEnabled = flashEnabled
        if takePhoto {
            uiViewController.capturePhoto()
            takePhoto = false
        }
    }
}

class CameraViewController: UIViewController {
    var captureSession: AVCaptureSession?
    var photoOutput: AVCapturePhotoOutput?
    var videoPreviewLayer: AVCaptureVideoPreviewLayer?
    var coordinator: CameraView.Coordinator?
    var flashEnabled = false

    override func viewDidLoad() {
        super.viewDidLoad()
        setupCamera()
    }

    func setupCamera() {
        captureSession = AVCaptureSession()
        guard let captureSession = captureSession else { return }

        guard let backCamera = AVCaptureDevice.default(for: .video),
              let input = try? AVCaptureDeviceInput(device: backCamera) else { return }

        photoOutput = AVCapturePhotoOutput()
        if captureSession.canAddInput(input) && captureSession.canAddOutput(photoOutput!) {
            captureSession.addInput(input)
            captureSession.addOutput(photoOutput!)
            videoPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
            videoPreviewLayer?.videoGravity = .resizeAspectFill
            videoPreviewLayer?.frame = view.layer.bounds
            if let videoPreviewLayer = videoPreviewLayer {
                view.layer.addSublayer(videoPreviewLayer)
            }
            captureSession.startRunning()
        }
    }

    func capturePhoto() {
        let settings = AVCapturePhotoSettings()
        settings.flashMode = flashEnabled ? .on : .off
        photoOutput?.capturePhoto(with: settings, delegate: coordinator!)
    }
}
