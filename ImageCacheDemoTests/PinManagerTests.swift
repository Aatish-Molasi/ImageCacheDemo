//
//  PinManagerTests.swift
//  ImageCacheDemoTests
//
//  Created by Aatish Molasi on 12/10/18.
//  Copyright © 2018 Aatish Molasi. All rights reserved.
//

import XCTest
@testable import ImageCacheDemo

class PinManagerTests: XCTestCase {
    var pinManager: PinManager!
    override func setUp() {
        super.setUp()
        pinManager = PinManager(urlSession: MockURLSession())
    }
    
    override func tearDown() {
        pinManager = nil
        super.tearDown()
    }
    
    func testFetchingPins() {
        pinManager.getPins(page: 1) { (pins, error) in
            XCTAssertNil(error)
            XCTAssertNotNil(pins)
            XCTAssert(pins?.count == PayloadStub.payloadWithData.count)
        }
    }

    //MARK: - Stubs
    class MockURLSession: URLSession {
        static var mockResponse: (data: Data?, urlResponse: URLResponse?, error: Error?) = (data: Data(), urlResponse: nil, error: nil)

        override func dataTask(with url: URL, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {
            return MockTask(response: MockURLSession.mockResponse, completionHandler: completionHandler)
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
            if let theJSONData = try?  JSONSerialization.data(
                withJSONObject: PayloadStub.payloadWithData,
                options: .prettyPrinted
                ),
                let theJSONText = String(data: theJSONData,
                                         encoding: String.Encoding.ascii) {
                print("JSON string = \n\(theJSONText)")
                completionHandler!(theJSONData, mockResponse.urlResponse, mockResponse.error)
            }
        }
    }
}
