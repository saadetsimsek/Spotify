//
//  SettingsModels.swift
//  Spotify
//
//  Created by Saadet Şimşek on 12/03/2024.
//

import Foundation

struct Section {
    let title: String
    let options: [Option]
}

struct Option{
    let title: String
    let handler: () -> Void
}
