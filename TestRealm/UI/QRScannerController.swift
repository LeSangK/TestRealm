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
    private let readQRResultService=ReadQRResultServiceImp()
    private let disposeBag = DisposeBag()

    public var readQRCode: ReadQRCode?
    public var viewModel: QRScannerViewModel?

    override func viewDidLoad() {
        super.viewDidLoad()

        //Replace me when SwinjectStoryboard imported
        readQRCode=ReadQRCodeImp(repository: realmRepository, service: readQRResultService )
        viewModel=QRScannerViewModel(readQRCode: readQRCode!)

        //カメラを初期化
        self.initlizeCamera()

        viewModel?.navigation
            .observeOn(MainScheduler.init())
            .subscribe(onNext: {[weak self] event in
                switch event {
                case _ as QRScannerViewModel.QRScannerComplete:
                    // stop the captureSession when qrReading success
                    self?.captureSession.stopRunning()
                    // swiftlint:disable:next force_cast
                    let parentVC = self?.presentingViewController as! ViewController
                    parentVC.table.reloadData()
                    self?.presentingViewController?.dismiss(animated: true, completion: nil)
                case _ as QRScannerViewModel.QRScannerCancel:
                    self?.dismiss(animated: true, completion: nil)
                case let event as QRScannerViewModel.ShowMessage:
                    self?.showMessga(event: event)
                default:
                    break
                }
            })
            .disposed(by: disposeBag)

        //キャンセルボタン
        cancelButton.rx.tap
            .subscribe(onNext: {[self]_ in
                self.viewModel?.startReadQRCode(resultString: nil, errorCode: .cancel)
            })
            .disposed(by: disposeBag)

    }

    // MARK: - Helper methods

    func showMessga(event: QRScannerViewModel.ShowMessage) {
        self.messageLabel.text=event.message
    }

}

// MARK: - MetadataOutput
extension QRScannerController: AVCaptureMetadataOutputObjectsDelegate {

    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        // Check if the metadataObjects array is not nil and it contains at least one object.
        if metadataObjects.count == 0 {
            qrCodeFrameView?.frame = CGRect.zero
            viewModel?.startReadQRCode(resultString: nil, errorCode: .noQrCode)
            return
        }

        // Get the metadata object.
        // swiftlint:disable force_cast
        let metadataObj = metadataObjects[0] as! AVMetadataMachineReadableCodeObject

        if AVMetadataObject.ObjectType.qr==metadataObj.type {
            // If the found metadata is equal to the QR code metadata (or barcode) then update the status label's text and set the bounds
            let barCodeObject = videoPreviewLayer?.transformedMetadataObject(for: metadataObj)
            qrCodeFrameView?.frame = barCodeObject!.bounds

            guard let resultString=metadataObj.stringValue else {
                return
            }

            viewModel?.startReadQRCode(resultString: resultString, errorCode: nil)
        }

    }
}

// MARK: - CameraViewInitializer
extension QRScannerController {

    func initlizeCamera() {
        // Get the back-facing camera for capturing videos
        guard let captureDevice = AVCaptureDevice.default(for: AVMediaType.video) else {
            viewModel?.startReadQRCode(resultString: nil, errorCode: .notSupport)
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
    }
}
