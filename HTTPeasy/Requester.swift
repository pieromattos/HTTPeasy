//
//  Requester.swift
//  HTTPeasy
//
//  Created by Piero Mattos on 28/07/19.
//  Copyright © 2019 Piero Mattos. All rights reserved.
//

import Foundation

/// The `Requester` protocol described the expected interface that an object must have
/// in order to act as the performer of HTTP requests.
public protocol Requester {
    func request(_ descriptor: Request.Descriptor, completionHandler: @escaping (_ data: Data?, _ error: Request.RequestError?) -> Void)
}
