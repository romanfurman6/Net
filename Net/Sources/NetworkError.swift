//
//  NetworkError.swift
//  Net
//
//  Created by Arthur Myronenko on 1/29/18.
//  Copyright © 2018 UPTech Team. All rights reserved.
//

import Foundation

public enum NetworkError<APIErrorResponse: Decodable & Error> {
  case serializationError(message: String)
  case apiError(APIErrorResponse)
  case sessionError(message: String)
  case unknown(NetworkResponse)
}

extension NetworkError: LocalizedError {
  public var errorDescription: String? {
    switch self {
    case let .sessionError(message):
      return message
    case let .serializationError(message):
      return "Serialization: \(message)"
    case let .apiError(apiErrorResponse):
      return "\(apiErrorResponse.localizedDescription)"
    case let .unknown(response):
      return "Unknown: \(response)"
    }
  }
}
