//
//  SharedDownloadmanagerTests.swift
//  ImageCacheManagerTests
//
//  Created by Aatish Molasi on 12/10/18.
//  Copyright © 2018 Aatish Molasi. All rights reserved.
//

import XCTest
@testable import ImageCacheManager

class SharedDownloadmanagerTests: XCTestCase {
    var sharedDownloadManger: DownloadManager!
    override func setUp() {
        super.setUp()
        sharedDownloadManger = DownloadManager(cacheManager: MockCacheManager(), session: MockURLSession(), dataLoader: DataLoaderStub())
    }
    
    override func tearDown() {
        sharedDownloadManger = nil
        super.tearDown()
    }

    //MARK: - Tests
    func testSuccessfulDownload() {
        let imageUrl = URL(string: ImageData.workingImageUrl)!
        let expectation = self.expectation(description: "Getting image")
        let downloadRequest = sharedDownloadManger.downloadFromUrl(url: imageUrl, cacheType: .none) { (data, error, finished, url, cacheType) in
            XCTAssertNotNil(data)
            XCTAssertNil(error)
            XCTAssertNotNil(url)
            XCTAssertTrue(cacheType == .none)
            expectation.fulfill()
        }
        XCTAssertNotNil(downloadRequest)
        XCTAssertTrue(downloadRequest.currentUrl == imageUrl)
        waitForExpectations(timeout: 2, handler: nil)
    }

    func testFailedDownload() {
        let imageUrl = URL(string: ImageData.failingImageUrl)!
        let expectation = self.expectation(description: "Getting image")
        let downloadRequest = sharedDownloadManger.downloadFromUrl(url: imageUrl, cacheType: .none) { (data, error, finished, url, cacheType) in
            XCTAssertNil(data)
            XCTAssertNotNil(error)
            XCTAssertNotNil(url)
            XCTAssertTrue(cacheType == .none)
            expectation.fulfill()
        }
        XCTAssertNotNil(downloadRequest)
        XCTAssertTrue(downloadRequest.currentUrl == imageUrl)
        waitForExpectations(timeout: 4, handler: nil)
    }

    func testCancelDownload() {
        let imageUrl = URL(string: ImageData.stallingImageUrl)!
        XCTAssertTrue(sharedDownloadManger.completionHandlers.count == 0)
        let downloadRequest = sharedDownloadManger.downloadFromUrl(url: imageUrl, cacheType: .none) { (data, error, finished, url, cacheType) in
        }
        XCTAssertTrue(sharedDownloadManger.completionHandlers.count == 1)
        downloadRequest.cancelCurrentDownload()
        XCTAssertTrue(sharedDownloadManger.completionHandlers.count == 0)
    }

    //MARK: - Stubs
    class MockCacheManager: ContentCacheManager {
        override func downloadedContent(content: Data, url:URL, cacheType: CacheType) {}
    }

    class MockURLSession: URLSession {
        static var mockResponse: (data: Data?, urlResponse: URLResponse?, error: Error?) = (data: Data(), urlResponse: nil, error: nil)

        override func dataTask(with url: URL, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) ->
            URLSessionDataTask {
                let response = URLResponse(url: url, mimeType: nil, expectedContentLength: 1, textEncodingName: nil)
                let mockResponse: (data: Data?, urlResponse: URLResponse?, error: Error?) = (data: Data(), urlResponse: response, error: nil)
            return MockTask(response: mockResponse, completionHandler: completionHandler)
        }
    }

    class MockTask: URLSessionDataTask {
        typealias Response = (data: Data?, urlResponse: URLResponse?, error: Error?)
        var mockResponse: Response
        let completionHandler: ((Data?, URLResponse?, Error?) -> Void)?

        init(response: Response, completionHandler: ((Data?, URLResponse?, Error?) -> Void)?) {
            self.mockResponse = response
            self.completionHandler = completionHandler
        }

        override func resume() {
            if mockResponse.urlResponse?.url?.absoluteString == ImageData.workingImageUrl {
                completionHandler!(Data(), mockResponse.urlResponse, nil)
            } else if mockResponse.urlResponse?.url?.absoluteString == ImageData.failingImageUrl {
                completionHandler!(nil, mockResponse.urlResponse, MyError.runtimeError("failed to download"))
            } else if mockResponse.urlResponse?.url?.absoluteString == ImageData.stallingImageUrl {
                sleep(2)
                completionHandler!(Data(), mockResponse.urlResponse, nil)
            }
        }
    }

    class DataLoaderStub: DataLoader {
        override func getData(url: URL) throws -> Data {
            if url.absoluteString == ImageData.workingImageUrl {
                return Data()
            } else if url.absoluteString == ImageData.failingImageUrl {
                throw MyError.runtimeError("failed to download")
            } else if url.absoluteString == ImageData.stallingImageUrl {
                sleep(50)
                return Data()
            }
            return Data()
        }
    }

    enum MyError: Error {
        case runtimeError(String)
    }
}
