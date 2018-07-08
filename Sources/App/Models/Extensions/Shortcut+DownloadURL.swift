//
//  Shortcut+DownloadURL.swift
//  App
//
//  Created by Guilherme Rambo on 08/07/18.
//

import Foundation
import Vapor

extension Shortcut {

    enum GenerateURLError: Error {
        case missingID
        case parseURL
        case generateURL

        var localizedDescription: String {
            switch self {
            case .missingID:
                return "Can't generate download URL for a shortcut without an ID"
            case .parseURL:
                return "Unable to parse deep link base URL"
            case .generateURL:
                return "Unable to generate URL"
            }
        }
    }

    func generateDeepLinkURL() throws -> URL {
        guard let identifier = self.id else { throw GenerateURLError.missingID }

        let downloadURL = "https://sharecuts.app/download/\(identifier).shortcut"

        guard var deepLinkComponents = URLComponents(string: "shortcuts://import-workflow") else {
            throw GenerateURLError.parseURL
        }

        deepLinkComponents.queryItems = [
            URLQueryItem(name: "url", value: downloadURL),
            URLQueryItem(name: "name", value: title)
        ]

        guard let url = deepLinkComponents.url else {
            throw GenerateURLError.generateURL
        }

        return url
    }

}
