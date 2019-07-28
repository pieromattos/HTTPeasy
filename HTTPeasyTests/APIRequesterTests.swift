//
//  APIRequesterTests.swift
//  HTTPeasy
//
//  Created by Piero Mattos on 28/07/19.
//  Copyright © 2019 Piero Mattos. All rights reserved.
//

import XCTest
@testable import HTTPeasy

class APIRequesterTests: XCTestCase {

    func test_request_descriptor() {

        let testMethod = Request.Method.GET
        let testUrl = "https://website.com"
        let testParams = ["p1": "a", "p2": "b"]
        let testHeaders = ["Authentication": "abc"]
        let testDescriptor = Request.Descriptor(method: testMethod, url: testUrl, params: testParams, headers: testHeaders)

        let urlSessionMock = URLSessionMock()
        let testInstance = APIRequester()
        testInstance.session = urlSessionMock

        testInstance.request(testDescriptor) { _, _ in }

        guard
            let request = urlSessionMock.lastRequest,
            let headers = request.allHTTPHeaderFields,
            let urlString = request.url?.absoluteString
            else { return XCTFail("A request should have been passed to the Session object.") }

        XCTAssertEqual(request.httpMethod, "GET")
        XCTAssertTrue(headers.contains(where: { $0 == "Authentication" && $1 == "abc" }))
        XCTAssertTrue(urlString == "https://website.com?p1=a&p2=b" || urlString == "https://website.com?p2=b&p1=a")
        XCTAssertEqual(request.httpBody, nil)
    }

    func test_request_success() {
        let expectation = XCTestExpectation(description: "Completion hadnler should be called with the returned data")

        let testUrl = "https://website.com"
        let testMethod = Request.Method.POST
        let testParams = ["p1": "a", "p2": "b"]
        let testHeaders = ["Authentication": "abc"]
        let testDescriptor = Request.Descriptor(method: testMethod, url: testUrl, params: testParams, headers: testHeaders)

        let data = Data()
        let response = HTTPURLResponse(url: URL(string: testUrl)!, statusCode: 200, httpVersion: "1.1", headerFields: nil)
        let urlSessionMock = URLSessionMock(desiredResponse: (data, response, nil))
        let testInstance = APIRequester()
        testInstance.session = urlSessionMock

        testInstance.request(testDescriptor) { responseData, error in
            if let responseData = responseData, error == nil, responseData == data {
                expectation.fulfill()
            }
        }

        wait(for: [expectation], timeout: 2.0)
    }

    func test_request_failure() {
        let expectation = XCTestExpectation(description: "Completion hadnler should be called with an error")

        let testMethod = Request.Method.POST
        let testUrl = "https://website.com"
        let testParams = ["p1": "a", "p2": "b"]
        let testHeaders = ["Authentication": "abc"]
        let testDescriptor = Request.Descriptor(method: testMethod, url: testUrl, params: testParams, headers: testHeaders)

        let response = HTTPURLResponse(url: URL(string: testUrl)!, statusCode: 501, httpVersion: "1.1", headerFields: nil)
        let urlSessionMock = URLSessionMock(desiredResponse: (nil, response, nil))
        let testInstance = APIRequester()
        testInstance.session = urlSessionMock

        testInstance.request(testDescriptor) { _, error in
            if error != nil {
                expectation.fulfill()
            }
        }

        wait(for: [expectation], timeout: 2.0)
    }
}
