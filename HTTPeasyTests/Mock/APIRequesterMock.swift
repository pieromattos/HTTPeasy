//
//  APIRequesterMock.swift
//  HTTPeasyTests
//
//  Created by Piero Mattos on 28/07/19.
//  Copyright © 2019 Piero Mattos. All rights reserved.
//

import Foundation
@testable import HTTPeasy

class APIRequesterMock: Requester {

    // MARK: - Auxiliary properties

    var lastDescriptor: Request.Descriptor?
    var desiredResponse: (Data?, Request.RequestError?)

    // MARK: - Auxiliary methods

    init(desiredResponse: (Data?, Request.RequestError?) = (nil, nil)) {
        self.desiredResponse = desiredResponse
    }

    // MARK: - Requester conformance

    func request(_ descriptor: Request.Descriptor, completionHandler: @escaping (Data?, Request.RequestError?) -> Void) {
        self.lastDescriptor = descriptor
        completionHandler(desiredResponse.0, desiredResponse.1)
    }
}
