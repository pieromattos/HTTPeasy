//
//  Request.swift
//  HTTPeasy
//
//  Created by Piero Mattos on 28/07/19.
//  Copyright © 2019 Piero Mattos. All rights reserved.
//

import Foundation

/// The Request struct contains the pertinent types
/// to be used for creating and performing API requests.
public struct Request {

    /// Describes how an API call should be made.
    /// The URL, method, parameters, and headers are defined in the descriptor.
    public struct Descriptor {
        public var method: Request.Method
        public var url: String
        public var params: [String: Any]?
        public var headers: [String: Any]?

        /// Initializes a new Request.Descriptor with the parameters passed in.
        ///
        /// - Parameters:
        ///   - method: The HTTP method to be used for the request.
        ///   - url: The URL to be used for the request.
        ///   - params: Any parameters that are to be sent with the request.
        ///   - headers: Any headers that are to be sent with the request.
        public init(_ method: Request.Method, _ url: String, _ params: [String: Any]? = nil, _ headers: [String: Any]? = nil) {
            self.method = method
            self.url = url
            self.params = params
            self.headers = headers
        }
    }

    /// Supported HTTP request methods.
    public enum Method: String {
        case GET, POST, PUT, DELETE
    }

    /// Encapsulates possible request errors. Has an error type for each common possible
    /// error and a `defaultError` static property to represent unknown/unhandled errors.
    ///
    /// Possible errors:
    /// - unknown: An unknown error occured.
    /// - serverUnreachable: The server was unreachable. Possibly due to a network issue.
    /// - requestError: The request was malformed before being sent to the server.
    /// - badRequest: There was an issue with how the request was formed.
    /// - unauthorized: Request is not authorized, please check credentials.
    /// - forbidden: Resource is not available to the authenticated user.
    /// - notFound: Resource not found or unavailable.
    /// - internalServer: An internal server error happened when processing the request.
    /// - couldNotDecodeResponseData: The request was successful, but the response data could not be properly decoded.
    public enum RequestError: Error {
        case unknown
        case serverUnreachable
        case requestError
        case badRequest
        case unauthorized
        case forbidden
        case notFound
        case internalServer
        case couldNotDecodeResponseData

        /// Translates an HTTP status code into
        /// a `RequestError`. If `nil` is returned, the response
        /// was successful (status code was in the 200-399 range)
        internal static func forStatus(_ statusCode: Int) -> RequestError? {
            switch statusCode {
            case 200..<400: return nil
            case 400:       return .badRequest
            case 401:       return .unauthorized
            case 403:       return .forbidden
            case 404:       return .notFound
            case 500..<600: return .internalServer
            default:        return .unknown
            }
        }
    }
}
