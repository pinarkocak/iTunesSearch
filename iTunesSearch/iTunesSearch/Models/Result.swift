//
//  Result.swift
//  iTunesSearch
//
//  Created by Pınar Koçak on 25.02.2022.
//

import Foundation

struct Result: Codable, Hashable {
    let wrapperType: String?
    let kind: String?
    let artistName: String?
    let trackName: String?
    let artworkUrl100: String?
    let trackPrice: Double?
    let releaseDate: String?
    let country: String?
    let currency: String?
    let primaryGenreName: String?
    let longDescription: String?
    let description: String?
    let collectionName: String?
}
