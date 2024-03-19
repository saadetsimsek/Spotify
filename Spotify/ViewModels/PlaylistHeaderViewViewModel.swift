//
//  PlaylistHeaderViewViewModel.swift
//  Spotify
//
//  Created by Saadet Şimşek on 19/03/2024.
//

import Foundation

struct PlaylistHeaderViewViewModel: Codable {
    let name: String?
    let ownerName: String?
    let description: String?
    let artworkURL: URL?
}
