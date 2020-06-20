//
//  QRScannerController.swift
//  QRCodeReader
//
//  Created by Simon Ng on 13/10/2016.
//  Copyright © 2016 AppCoda. All rights reserved.
//

import UIKit
import AVFoundation
import RxSwift
import RxCocoa

class QRScannerController: UIViewController {

    @IBOutlet var messageLabel: UILabel!
    @IBOutlet var cancelButton: UIButton!

    var captureSession = AVCaptureSession()
    var videoPreviewLayer: AVCaptureVideoPreviewLayer?
    var qrCodeFrameView: UIView?

    private let realmRepository = RealmRepositoryImp()
    private let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Get the back-facing camera for capturing videos
        guard let captureDevice = AVCaptureDevice.default(for: AVMediaType.video) else {
            messageLabel.text="Failed to get the camera device"
            return
        }

        do {
            // Get an instance of the AVCaptureDeviceInput class using the previous device object.
            let input = try AVCaptureDeviceInput(device: captureDevice)

            // Set the input device on the capture session.
            captureSession.addInput(input)

            // Initialize a AVCaptureMetadataOutput object and set it as the output device to the capture session.
            let captureMetadataOutput = AVCaptureMetadataOutput()
            captureSession.addOutput(captureMetadataOutput)

            // Set delegate and use the default dispatch queue to execute the call back
            captureMetadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
            //            captureMetadataOutput.metadataObjectTypes = supportedCodeTypes
            captureMetadataOutput.metadataObjectTypes = [AVMetadataObject.ObjectType.qr]

        } catch {
            // If any error occurs, simply print it out and don't continue any more.
            print(error)
            return
        }

        // Initialize the video preview layer and add it as a sublayer to the viewPreview view's layer.
        videoPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        videoPreviewLayer?.videoGravity = AVLayerVideoGravity.resizeAspectFill
        videoPreviewLayer?.frame = view.layer.bounds
        view.layer.addSublayer(videoPreviewLayer!)

        // Start video capture.
        captureSession.startRunning()

        // Move the message label and top bar to the front
        view.bringSubviewToFront(messageLabel)
        view.bringSubviewToFront(cancelButton)

        // Initialize QR Code Frame to highlight the QR code
        qrCodeFrameView = UIView()

        if let qrCodeFrameView = qrCodeFrameView {
            qrCodeFrameView.layer.borderColor = UIColor.green.cgColor
            qrCodeFrameView.layer.borderWidth = 2
            view.addSubview(qrCodeFrameView)
            view.bringSubviewToFront(qrCodeFrameView)
        }

        //キャンセルボタン
        cancelButton.rx.tap
            .subscribe(onNext: {[self]_ in
                self.dismiss(animated: true, completion: nil)
            })
            .disposed(by: disposeBag)

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Helper methods

    func launchApp(decodedURL: String) {

        if presentedViewController != nil {
            return
        }

        let alertPrompt = UIAlertController(title: "Open App", message: "You're going to add \(decodedURL) in table", preferredStyle: .actionSheet)

        let confirmAction = UIAlertAction(title: "Confirm", style: UIAlertAction.Style.default, handler: { (_) -> Void in
            let todo: TodoModel = TodoModel()
            todo.text=decodedURL
            self.realmRepository.addNewTodo(todo: todo)
            self.unwindToHomeScreen()
        })

        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel, handler: nil)

        alertPrompt.addAction(confirmAction)
        alertPrompt.addAction(cancelAction)

        present(alertPrompt, animated: true, completion: nil)
    }

    func unwindToHomeScreen() {
        // swiftlint:disable:next force_cast
        let parentVC = presentingViewController as! ViewController
        parentVC.table.reloadData()
        self.presentingViewController?.dismiss(animated: true, completion: nil)
    }

    private func updatePreviewLayer(layer: AVCaptureConnection, orientation: AVCaptureVideoOrientation) {
        layer.videoOrientation = orientation
        videoPreviewLayer?.frame = self.view.bounds
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        if let connection =  self.videoPreviewLayer?.connection {
            let currentDevice: UIDevice = UIDevice.current
            let orientation: UIDeviceOrientation = currentDevice.orientation
            let previewLayerConnection: AVCaptureConnection = connection

            if previewLayerConnection.isVideoOrientationSupported {
                switch orientation {
                case .portrait:
                    updatePreviewLayer(layer: previewLayerConnection, orientation: .portrait)
                case .landscapeRight:
                    updatePreviewLayer(layer: previewLayerConnection, orientation: .landscapeLeft)
                case .landscapeLeft:
                    updatePreviewLayer(layer: previewLayerConnection, orientation: .landscapeRight)
                case .portraitUpsideDown:
                    updatePreviewLayer(layer: previewLayerConnection, orientation: .portraitUpsideDown)
                default:
                    updatePreviewLayer(layer: previewLayerConnection, orientation: .portrait)
                }
            }
        }
    }

}

// MARK: - MetadataOutput
extension QRScannerController: AVCaptureMetadataOutputObjectsDelegate {

    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        // Check if the metadataObjects array is not nil and it contains at least one object.
        if metadataObjects.count == 0 {
            qrCodeFrameView?.frame = CGRect.zero
            messageLabel.text = "No QR code is detected"
            return
        }

        // Get the metadata object.
        //        swiftlint:disable force_cast
        let metadataObj = metadataObjects[0] as! AVMetadataMachineReadableCodeObject

        if AVMetadataObject.ObjectType.qr==metadataObj.type {
            // If the found metadata is equal to the QR code metadata (or barcode) then update the status label's text and set the bounds
            let barCodeObject = videoPreviewLayer?.transformedMetadataObject(for: metadataObj)
            qrCodeFrameView?.frame = barCodeObject!.bounds

            guard let resultString=metadataObj.stringValue else {
                return
            }
            let readQRResultService=ReadQRResultServiceImp(result: resultString)
            let ressult=readQRResultService.readQRResultHandler()
            messageLabel.text = ressult.clientId

        }
    }
}
