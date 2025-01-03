//
//  QRCodeScannerView.swift
//  DailyPhoto
//
//  Created by 伊藤璃乃 on 2025/01/03.
//

import SwiftUI
import AVFoundation

struct QRCodeScannerView: UIViewControllerRepresentable {
    class Coordinator: NSObject, AVCaptureMetadataOutputObjectsDelegate {
        var parent: QRCodeScannerView

        init(parent: QRCodeScannerView) {
            self.parent = parent
        }

        func metadataOutput(
            _ output: AVCaptureMetadataOutput,
            didOutput metadataObjects: [AVMetadataObject],
            from connection: AVCaptureConnection
        ) {
            if let metadataObject = metadataObjects.first as? AVMetadataMachineReadableCodeObject,
               metadataObject.type == .qr,
               let stringValue = metadataObject.stringValue {
                parent.completion(stringValue)
            }
        }
    }

    var completion: (String) -> Void

    func makeCoordinator() -> Coordinator {
        return Coordinator(parent: self)
    }

    func makeUIViewController(context: Context) -> UIViewController {
        let viewController = UIViewController()
        let session = AVCaptureSession()

        guard let videoCaptureDevice = AVCaptureDevice.default(for: .video) else {
            return viewController
        }

        let videoInput: AVCaptureDeviceInput
        do {
            videoInput = try AVCaptureDeviceInput(device: videoCaptureDevice)
        } catch {
            return viewController
        }

        if session.canAddInput(videoInput) {
            session.addInput(videoInput)
        } else {
            return viewController
        }

        let metadataOutput = AVCaptureMetadataOutput()
        if session.canAddOutput(metadataOutput) {
            session.addOutput(metadataOutput)

            metadataOutput.setMetadataObjectsDelegate(context.coordinator, queue: DispatchQueue.main)
            metadataOutput.metadataObjectTypes = [.qr]
        } else {
            return viewController
        }

        let previewLayer = AVCaptureVideoPreviewLayer(session: session)
        previewLayer.frame = viewController.view.layer.bounds
        previewLayer.videoGravity = .resizeAspectFill
        viewController.view.layer.addSublayer(previewLayer)

        session.startRunning()

        return viewController
    }

    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {}
}
