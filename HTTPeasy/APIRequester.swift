//
//  APIRequester.swift
//  HTTPeasy
//
//  Created by Piero Mattos on 28/07/19.
//  Copyright © 2019 Piero Mattos. All rights reserved.
//

import Foundation

internal protocol Session {
    init(configuration: URLSessionConfiguration)
    func dataTask(with: URLRequest, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask
}

extension URLSession: Session {}

/// APIRequester is the default class from HTTPeasy that enables HTTP requests to be
/// performed. If you do not need any customization of how requests are done, you
/// should probably use the shared instance of this class to perform your requests.
public class APIRequester: Requester {

    // MARK: - Shared instance

    /// A shared instance to be used for HTTP requests
    public static var shared = APIRequester()

    // MARK: - Properties

    internal var session: Session

    // MARK: - Initialization

    /// Initializes a new instance of APIRequester
    ///
    /// - Parameter sessionConfiguration: an optional configuration object to be used for the requests.
    public init(sessionConfiguration: URLSessionConfiguration? = nil) {
        if let config = sessionConfiguration {
            self.session = URLSession(configuration: config)
        } else {
            let sessionConfig = URLSessionConfiguration.default
            sessionConfig.requestCachePolicy = .reloadIgnoringLocalCacheData
            sessionConfig.timeoutIntervalForRequest = 60.0
            sessionConfig.httpAdditionalHeaders = ["Content-Type": "application/json" ]
            self.session = URLSession(configuration: sessionConfig)
        }
    }

    // MARK: - Methods

    /// Executes an HTTP request based on the `RequestDescriptor` passed in.
    ///
    /// - Parameters:
    ///   - descriptor: The Request.Descriptor instance describing the request to be performed.
    ///   - completionHandler: A completion handler to be executed after the request is performed.
    public func request(_ descriptor: Request.Descriptor, completionHandler: @escaping (_ data: Data?, _ error: Request.RequestError?) -> Void) {

        guard
            var request = request(forDescriptor: descriptor)
            else { return completionHandler(nil, .requestError) }

        setHeaders(of: &request, descriptor: descriptor)
        setParams(of: &request, descriptor: descriptor)
        perform(request, withHandler: completionHandler)
    }

    /// Returns the request to be performed based on a Request.Descriptor.
    private func request(forDescriptor descriptor: Request.Descriptor) -> URLRequest? {
        guard
            let requestUrl = URL(string: descriptor.url)
            else { return nil }

        var request = URLRequest(url: requestUrl, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 60.0)
        request.httpMethod = descriptor.method.rawValue

        return request
    }

    /// Sets the descriptor headers on the passed request, if there are any.
    /// Also sets the Basic Authentication header that is used for all requests.
    private func setHeaders(of request: inout URLRequest, descriptor: Request.Descriptor) {
        if let headers = descriptor.headers {
            headers.forEach { header in
                request.setValue(header.value as? String, forHTTPHeaderField: header.key)
            }
        }
    }

    /// Sets the descriptor parameters on the passed request, if there are any.
    private func setParams(of request: inout URLRequest, descriptor: Request.Descriptor) {
        if let parameters = descriptor.params {
            if descriptor.method == .GET || descriptor.method == .DELETE {
                appendToURL(ofRequest: &request, parameters: parameters)
            } else {
                setBody(ofRequest: &request, parameters: parameters)
            }
        }
    }

    /// Performs the request passed in.
    private func perform(_ request: URLRequest, withHandler handler: @escaping (_ data: Data?, _ error: Request.RequestError?) -> Void) {
        session.dataTask(with: request) { data, res, error in
            if let error = error {
                handler(nil, self.requestError(forError: error))
            } else if let response = res as? HTTPURLResponse {
                handler(data, .forStatus(response.statusCode))
            } else {
                handler(nil, .unknown)
            }
        }.resume()
    }

    /// Appends the passed parameters to the request's URL string.
    private func appendToURL(ofRequest request: inout URLRequest, parameters: [String: Any]) {

        let paramsString = parameters.enumerated().flatMap { offset, element -> String in
            return "\(offset == 0 ? "" : "&")\(element.key)=\(element.value)"
        }

        guard let originalUrl = request.url?.absoluteString else { return }
        request.url = URL(string: originalUrl + "?" + paramsString)
    }

    /// Serializes the parameters passed and set's the serialization
    /// result as the body of the request.
    private func setBody(ofRequest request: inout URLRequest, parameters: [String: Any]) {
        guard
            let serializedBodyParams = try? JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted)
            else { return }

        request.httpBody = serializedBodyParams
    }

    /// Translate a request error into a `RequestError`
    private func requestError(forError error: Error) -> Request.RequestError {
        let nsError = error as NSError
        return nsError.code == -1003 ? .serverUnreachable : .requestError
    }
}
