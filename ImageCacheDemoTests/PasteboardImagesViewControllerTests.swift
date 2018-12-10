//
//  PasteboardImagesViewControllerTests.swift
//  ImageCacheDemoTests
//
//  Created by Aatish Molasi on 12/10/18.
//  Copyright © 2018 Aatish Molasi. All rights reserved.
//

import Foundation
import XCTest

@testable import ImageCacheDemo
class PasteboardImagesViewControllerTests: XCTestCase {
    var viewController: PasteboardImagesViewController?

    override func setUp() {
        super.setUp()
        //Need a better way to handle the internal dependency injection
        viewController = PasteboardImagesViewController(pinManager: MockPinManager(urlSession: URLSession.shared))
    }

    override func tearDown() {
        viewController = nil
        super.tearDown()
    }

    class MockPinManager: PinManager {

    }
}
