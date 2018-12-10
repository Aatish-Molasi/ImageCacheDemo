//
//  ImageCacheManagerTests.swift
//  ImageCacheManagerTests
//
//  Created by Aatish Molasi on 12/8/18.
//  Copyright © 2018 Aatish Molasi. All rights reserved.
//

import XCTest
@testable import ImageCacheManager

class ContentCacheManagerTests: XCTestCase {
    var cacheManager: ContentCacheManager!
    override func setUp() {
        super.setUp()
        cacheManager = ContentCacheManager()
    }
    
    override func tearDown() {
        cacheManager = nil
        super.tearDown()
    }
    
    func testCacheContentBeingStoredInMemory() {
        let imageUrl = ImageData.workingImageUrl
        XCTAssertNil(cacheManager.cachedContent[imageUrl])
        XCTAssertTrue(cacheManager.cacheSize > 0)
        cacheManager.downloadedContent(content: Data(), url: URL(string: imageUrl)!, cacheType: .memory)
        XCTAssertNotNil(cacheManager.cachedContent[imageUrl])
    }

    func testCacheContentNotBeingStoredInMemory() {
        let imageUrl = ImageData.workingImageUrl
        XCTAssertNil(cacheManager.cachedContent[imageUrl])
        XCTAssertTrue(cacheManager.cacheSize > 0)
        cacheManager.downloadedContent(content: Data(), url: URL(string: imageUrl)!, cacheType: .none)
        XCTAssertNil(cacheManager.cachedContent[imageUrl])
    }

    func testCacheNotBeingStoredFor0CacheSize() {
        let imageUrl = ImageData.workingImageUrl
        XCTAssertNil(cacheManager.cachedContent[imageUrl])
        cacheManager.setCacheSize(cacheSize: 0)
        XCTAssertTrue(cacheManager.cacheSize == 0)
        cacheManager.downloadedContent(content: Data(), url: URL(string: imageUrl)!, cacheType: .memory)
        XCTAssertNil(cacheManager.cachedContent[imageUrl])
    }

    func testLRUImageDeletion() {
        let imageUrl1 = ImageData.workingImageUrl+"1"
        let imageUrl2 = ImageData.workingImageUrl+"2"
        let imageUrl3 = ImageData.workingImageUrl+"3"
        let imageUrl4 = ImageData.workingImageUrl+"4"

        cacheManager.setCacheSize(cacheSize: 3)

        cacheManager.downloadedContent(content: Data(), url: URL(string: imageUrl1)!, cacheType: .memory)
        cacheManager.downloadedContent(content: Data(), url: URL(string: imageUrl2)!, cacheType: .memory)
        cacheManager.downloadedContent(content: Data(), url: URL(string: imageUrl3)!, cacheType: .memory)
        cacheManager.downloadedContent(content: Data(), url: URL(string: imageUrl4)!, cacheType: .memory)

        XCTAssertNil(cacheManager.cachedContent[imageUrl1])
        XCTAssertNotNil(cacheManager.cachedContent[imageUrl2])
        XCTAssertNotNil(cacheManager.cachedContent[imageUrl3])
        XCTAssertNotNil(cacheManager.cachedContent[imageUrl4])
    }

    func testCacheInvalidation() {
        let imageUrl = ImageData.workingImageUrl
        let imageUrl2 = ImageData.workingImageUrl+"2"

        cacheManager.downloadedContent(content: Data(), url: URL(string: imageUrl)!, cacheType: .memory)
        cacheManager.downloadedContent(content: Data(), url: URL(string: imageUrl2)!, cacheType: .memory)

        XCTAssertTrue(cacheManager.cachedContent.count == 2)

        cacheManager.clearCache()

        XCTAssertTrue(cacheManager.cachedContent.count == 0)
    }
}
