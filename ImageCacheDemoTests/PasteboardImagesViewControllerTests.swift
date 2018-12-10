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
        let _ = viewController?.view
        viewController?.viewDidLoad()
    }

    func testCheckViewsArePresent() {
        XCTAssertNotNil(viewController?.pinImagesTable);
    }

    func testDidGetPins() {
        XCTAssert(viewController?.pins.count == PayloadStub.payloadWithData.count)
    }

    override func tearDown() {
        viewController = nil
        super.tearDown()
    }

    //MARK: - Stubs
    class MockPinManager: PinManager {
        override func getPins(page: Int, completion: @escaping ([Pin]?, Error?) -> ()) {
            let pinsDictionary = PayloadStub.payloadWithData
            if let theJSONData = try?  JSONSerialization.data(
                withJSONObject: pinsDictionary,
                options: .prettyPrinted
                ) {
                do {
                    let result = try JSONDecoder().decode([Pin].self, from: theJSONData)
                    completion(result, nil)
                }
                catch {
                    completion([], error)
                }
            }
        }

        enum MyError: Error {
            case runtimeError(String)
        }
    }
}
