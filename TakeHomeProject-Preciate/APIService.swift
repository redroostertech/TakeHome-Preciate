//
//  APIService.swift
//  TakeHomeProject-Preciate
//
//  Created by Michael Westbrooks II on 2/21/23.
//

import Foundation

enum APIError: Error {
    case invalidResponse
    case networkError
    case decodingError
}

enum APIResult<T> {
    case success(T)
    case failure(APIError)
}

enum APIUrl: String {
    case base = "https://example-api.social-ops.net/docs"
}

enum APIUrlEndpoint {
    case movies
    case movieWithId(Int)

    var value: String {
        switch self {
            case .movieWithId(let id):
                return "movies/\(id)"

            case .movies:
                return "movies?limit=50&offset=0"
        }
    }
}

protocol APIServiceProtocol {
    func fetch<T: Decodable>(completion: @escaping (APIResult<T>) -> Void)
}

final class APIService: APIServiceProtocol {
    private let urlSession: URLSession
    private let url: URL?

    init(
        endpoint: APIUrlEndpoint,
        apiUrl: APIUrl = .base,
        urlSession: URLSession = .shared
    ) {

        self.url = URL(
            string: endpoint.value,
            relativeTo: URL(string: apiUrl.rawValue)
        )
        self.urlSession = urlSession
    }

    func fetch<T: Decodable>(
        completion: @escaping (APIResult<T>) -> Void
    ) {
        guard let url else {
            completion(.failure(.invalidResponse))
            return
        }

        let task = urlSession.dataTask(
            with: url
        ) { data, response, error in
            guard error == nil else {
                completion(.failure(.networkError))
                return
            }

            guard let data = data else {
                completion(.failure(.invalidResponse))
                return
            }

            do {
                self.log(data)
                let decodedData = try JSONDecoder().decode(
                    T.self,
                    from: data
                )
                completion(.success(decodedData))
            } catch {
                completion(.failure(.decodingError))
            }
        }

        task.resume()
    }

    private func log(_ data: Data) {
        do {
            let jsonDict = try JSONSerialization.jsonObject(
                with: data,
                options: []
            ) as? [String: Any]
            print("Data from response: \(String(describing: jsonDict))")
        } catch {
            print("Error: \(error)")
        }
    }
}
