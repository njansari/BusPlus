//
//  URLSession+JSONDecode.swift
//  URLSession+JSONDecode
//
//  Created by Nayan Jansari on 07/08/2021.
//

import Foundation

extension URLSession {
    func decodeJSON<T: Decodable>(ofType type: T.Type = T.self, from url: URL) async throws -> T {
        let data = try await URLSession.shared.data(from: url).0
        let decoded = try JSONDecoder().decode(type, from: data)

        return decoded
    }
}
