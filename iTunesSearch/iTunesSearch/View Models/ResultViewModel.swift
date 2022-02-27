//
//  ResultViewModel.swift
//  iTunesSearch
//
//  Created by Pınar Koçak on 25.02.2022.
//

import Foundation

struct ResultViewModel {
    private let result: Result
}

extension ResultViewModel {
    init(_ result: Result) {
        self.result = result
    }
    
    var wrapperType: String {
        return self.result.wrapperType ?? ""
    }
    
    var kind: String {
        return self.result.kind ?? ""
    }
    
    var artistName: String {
        return self.result.artistName ?? ""
    }

    var trackName: String {
        return self.result.trackName ?? ""
    }
    
    var collectionName: String {
        return self.result.collectionName ?? ""
    }
    
    var artworkUrl100: String {
        return self.result.artworkUrl100 ?? ""
    }
    
    var trackPrice: Double {
        return self.result.trackPrice ?? 0.0
    }
    
    var releaseDate: String {
        return self.result.releaseDate ?? ""
    }

    var country: String {
        return self.result.country ?? ""
    }
    
    var currency: String {
        return self.result.currency ?? ""
    }
    
    var primaryGenreName: String {
        return self.result.primaryGenreName ?? ""
    }
    
    var longDescription: String {
        return self.result.longDescription ?? ""
    }
    
    var description: String {
        return self.result.description ?? ""
    }
}

