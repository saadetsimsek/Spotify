//
//  LibraryAlbumsRsponse.swift
//  Spotify
//
//  Created by Saadet Şimşek on 25/04/2024.
//

import Foundation

struct LibraryAlbumsRsponse: Codable {
    let item: [SavedAlbum]
}

struct SavedAlbum: Codable {
    let added_at: String
    let album: Album
}
