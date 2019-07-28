//
//  RequestTests.swift
//  HTTPeasyTests
//
//  Created by Piero Mattos on 28/07/19.
//  Copyright © 2019 Piero Mattos. All rights reserved.
//

import XCTest
@testable import HTTPeasy

class RequestTests: XCTestCase {

    func testDescriptorInitialization() {
        let testMethod: Request.Method = .GET
        let testUrl = "https://some_website.com"
        let testParams = ["param1": "8", "param2": "abc"]
        let testHeaders = ["header1": "Some-Value", "header2": "AnotherValue"]

        let testDescriptor = Request.Descriptor(method: testMethod, url: testUrl, params: testParams, headers: testHeaders)

        XCTAssertEqual(testMethod, testDescriptor.method)
        XCTAssertEqual(testUrl, testDescriptor.url)
        XCTAssertNotNilAndEqual(testDescriptor.params as? [String: String], testParams)
        XCTAssertNotNilAndEqual(testDescriptor.headers as? [String: String], testHeaders)
    }

    func testRequestErrorStatusCodeTranslation() {
        XCTAssertEqual(nil, Request.RequestError.forStatus(203))
        XCTAssertEqual(Request.RequestError.badRequest, Request.RequestError.forStatus(400))
        XCTAssertEqual(Request.RequestError.unauthorized, Request.RequestError.forStatus(401))
        XCTAssertEqual(Request.RequestError.forbidden, Request.RequestError.forStatus(403))
        XCTAssertEqual(Request.RequestError.notFound, Request.RequestError.forStatus(404))
        XCTAssertEqual(Request.RequestError.internalServer, Request.RequestError.forStatus(501))
        XCTAssertEqual(Request.RequestError.unknown, Request.RequestError.forStatus(650))
    }
}
