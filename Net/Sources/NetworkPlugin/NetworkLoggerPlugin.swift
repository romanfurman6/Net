//
//  NetworkLoggerPlugin.swift
//  Net
//
//  Created by Arthur Myronenko on 5/3/18.
//  Copyright © 2018 UPTech Team. All rights reserved.
//

import Foundation
import RxSwift

public final class NetworkLoggerPlugin: NetworkPlugin {

  public typealias Logger = (String) -> Void

  private let log: Logger

  public init(logger: @escaping Logger = { print($0) }) {
    self.log = logger
  }

  public func modifyRequest(_ urlRequest: URLRequest) -> URLRequest {
    let curlLogMessage = String(curlString(from: urlRequest).prefix(500))
    log(curlLogMessage)
    return urlRequest
  }

  public func handleResponse(_ response: NetworkResponse) {
    let stringData = String(data: response.data, encoding: .utf8) ?? "Invalid"
    let message = "Response: [\(response.statusCode)] \(stringData)"
    log(message)
  }

  private func curlString(from request: URLRequest) -> String {
    guard let url = request.url else { return "" }
    var baseCommand = "curl \(url.absoluteString)"

    if request.httpMethod == "HEAD" {
      baseCommand += " --head"
    }

    var command = [baseCommand]

    if let method = request.httpMethod, method != "GET" && method != "HEAD" {
      command.append("-X \(method)")
    }

    if let headers = request.allHTTPHeaderFields {
      for (key, value) in headers where key != "Cookie" {
        command.append("-H '\(key): \(value)'")
      }
    }

    if let data = request.httpBody, let body = String(data: data, encoding: .utf8) {
      command.append("-d '\(body)'")
    }

    return command.joined(separator: " \\\n\t")
  }
}
