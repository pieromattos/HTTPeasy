//
//  URLSessionMock.swift
//  HTTPeasyTests
//
//  Created by Piero Mattos on 28/07/19.
//  Copyright © 2019 Piero Mattos. All rights reserved.
//
// swiftlint:disable large_tuple

import Foundation
@testable import HTTPeasy

class URLSessionMock: Session {

    // MARK: - Auxiliary properties

    var desiredResponse: (Data?, URLResponse?, Error?)
    var lastRequest: URLRequest?

    // MARK: - Auxiliary methods

    init(desiredResponse: (Data?, URLResponse?, Error?) = (nil, nil, nil)) {
        self.desiredResponse = desiredResponse
    }

    // MARK: - Session conformance

    required init(configuration: URLSessionConfiguration) {
        desiredResponse = (nil, nil, nil)
    }

    func dataTask(with request: URLRequest, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {
        lastRequest = request
        completionHandler(desiredResponse.0, desiredResponse.1, desiredResponse.2)
        return URLSession.shared.dataTask(with: URL(string: "abc")!)
    }
}
