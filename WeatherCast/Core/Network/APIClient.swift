//  APIClient.swift
//  WeatherCast
//
//  Created by Eslam Elnady on 30/05/2026.
//

import Alamofire
import Foundation

enum APIError: Error, LocalizedError {
    case invalidResponse
    case decodingError(Error)
    case serverError(Int, String?)
    case noInternet
    case missingAPIKey

    var errorDescription: String? {
        switch self {
        case .invalidResponse:
            return "Invalid server response."
        case .decodingError(let error):
            return "Decoding failed: \(error.localizedDescription)"
        case .serverError(let code, _):
            return "Server error \(code)."
        case .noInternet:
            return "No internet connection."
        case .missingAPIKey:
            return "Missing WEATHER_API_KEY. Set it in Secrets.xcconfig."
        }
    }
}

final class APIClient {
    static let shared = APIClient()

    private init() {}

    func request<T: Decodable>(endpoint: Endpoint) async throws -> T {
        guard let apiKey = AppSecrets.weatherAPIKey else {
            throw APIError.missingAPIKey
        }

        var params = endpoint.parameters?.toDict() ?? [:]
        params["key"] = apiKey

        return try await withCheckedThrowingContinuation { continuation in
            AF.request(
                endpoint.fullURL,
                method: endpoint.method.alamofireMethod,
                parameters: params,
                encoding: URLEncoding.default
            )
            .validate()
            .responseDecodable(of: T.self) { response in
                switch response.result {
                case .success(let value):
                    continuation.resume(returning: value)
                case .failure(let afError):
                    if let statusCode = response.response?.statusCode {
                        let body = String(data: response.data ?? Data(), encoding: .utf8)
                        continuation.resume(throwing: APIError.serverError(statusCode, body))
                    } else if afError.isSessionTaskError {
                        continuation.resume(throwing: APIError.noInternet)
                    } else if let decodingError = afError.underlyingError {
                        continuation.resume(throwing: APIError.decodingError(decodingError))
                    } else {
                        continuation.resume(throwing: APIError.invalidResponse)
                    }
                }
            }
        }
    }
}

private extension HTTPMethod {
    var alamofireMethod: Alamofire.HTTPMethod {
        switch self {
        case .get:
            return .get
        case .post:
            return .post
        }
    }
}
