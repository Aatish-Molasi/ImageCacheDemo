//
//  UIImageCatergoryTests.swift
//  ImageCacheManagerTests
//
//  Created by Aatish Molasi on 12/10/18.
//  Copyright © 2018 Aatish Molasi. All rights reserved.
//

import XCTest
@testable import ImageCacheManager

class UIImageCatergoryTests: XCTestCase {
    var imageView: UIImageView!
    override func setUp() {
        super.setUp()
        imageView = UIImageView()
    }
    
    override func tearDown() {
        imageView = nil
        super.tearDown()
    }

    //Unfortunately managing dependency injection in catergories may not be as straight forward
    func testSettingImage() {
        let expectation = self.expectation(description: "Getting image")
        imageView.setImage(withURL: URL(string: ImageData.workingImageUrl), placeholderImage: nil) { (image, error, finished, url) in
            XCTAssertNotNil(image)
            XCTAssertNotNil(url)
            XCTAssertTrue(finished)
            expectation.fulfill()
        }
        waitForExpectations(timeout: 2, handler: nil)
    }

    func testSettingFailedImage() {
        let expectation = self.expectation(description: "Getting failed image")
        imageView.setImage(withURL: URL(string: ImageData.failingImageUrl), placeholderImage: nil) { (image, error, finished, url) in
            XCTAssertNil(image)
            XCTAssertNotNil(url)
            XCTAssertTrue(finished)
            expectation.fulfill()
        }
        waitForExpectations(timeout: 2, handler: nil)
    }
}
