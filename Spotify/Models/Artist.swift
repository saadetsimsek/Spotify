//
//  Artist.swift
//  Spotify
//
//  Created by Saadet Şimşek on 11/03/2024.
//

import Foundation

struct Artist: Codable{
    let id: String
    let name: String
    let type: String
    let external_urls: [String: String]
}
