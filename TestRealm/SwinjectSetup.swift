//
//  SwinjectSetup.swift
//
//  Created by 楽桑 on 2020/07/04.
//  Copyright © 2020 楽桑. All rights reserved.
//

import Foundation
import SwinjectStoryboard

extension SwinjectStoryboard {
    // swiftlint:disable function_body_length
    @objc class func setup() {
        //TodoDataStore
        defaultContainer.register(TodoDataStore.self) { _ in TodoDataStoreImp()}

        //ReadQRCodeRepository
        defaultContainer.register(ReadQRCodeRepository.self) { r in
            ReadQRCodeRepositoryImp(todoDataStore: r.resolve(TodoDataStore.self)!)
        }

        //ReadQRCode
        defaultContainer.register(ReadQRCode.self) { r in ReadQRCodeImp(repository: r.resolve(ReadQRCodeRepository.self)!)
        }

        //QRScannerViewModel
        defaultContainer.register(QRScannerViewModel.self) { r in
            QRScannerViewModel(readQRCode: r.resolve(ReadQRCode.self)!)
        }

        //QRScannerController
        defaultContainer.storyboardInitCompleted(QRScannerController.self) { (resolver, c) in
            c.viewModel = resolver.resolve(QRScannerViewModel.self)
        }

        //TodoRepository
        defaultContainer.register(TodoRepository.self) {r in TodoRepositoryImp(todoDataStore: r.resolve(TodoDataStore.self)!)}

        //TodoAction
        defaultContainer.register(TodoAction.self) { r in TodoActionImp(repository: r.resolve(TodoRepository.self)!)
        }

        //TodoViewModel
        defaultContainer.register(TodoViewModel.self) {r in TodoViewModel(todoAction: r.resolve(TodoAction.self)!)
        }

        //TodoController
        defaultContainer.storyboardInitCompleted(TodoViewController.self) { (resolver, c) in
            c.viewModel = resolver.resolve(TodoViewModel.self)
        }

    }
}
