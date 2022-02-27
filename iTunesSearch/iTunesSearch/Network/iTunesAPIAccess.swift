//
//  iTunesAPIAccess.swift
//  iTunesSearch
//
//  Created by Pınar Koçak on 25.02.2022.
//

import Foundation

class iTunesAPIAccess {
    
    private var condition: String = ""
    private var sortedResults = [Result]()
    private let defaults = UserDefaults.standard
    private var hasMoreData: Bool = true
    
    static var getAllObjects: [Result] {
        if let objects = UserDefaults.standard.value(forKey: "sortedResult") as? Data {
            let decoder = JSONDecoder()
            if let objectsDecoded = try? decoder.decode(Array.self, from: objects) as [Result] {
                return objectsDecoded
            }
        }
        return []
    }
    
    func getResults(firstCall: Bool, pagingIndex: Int, pagingSize: Int, term: String, completion: @escaping ([Result]?) -> ()) {
        if term != "" {
            condition = term.replacingOccurrences(of: " ", with: "")
        }
        guard let url = URL(string: "https://itunes.apple.com/search?term=\(condition)") else { return }
        
        if firstCall {
            URLSession.shared.dataTask(with: url) { data, response, error in
                if let error = error {
                    print(error.localizedDescription)
                    completion(nil)
                } else if let data = data {
                    let resultList = try? JSONDecoder().decode(ResultList.self, from: data)
                    
                    if let resultList = resultList {
                        self.sortedResults = resultList.results.sorted(by: { $0.wrapperType?.lowercased() ?? "" < $1.wrapperType?.lowercased() ?? "" })
                        iTunesAPIAccess.saveAllObjects(allObjects: self.sortedResults)
                        completion(self.pagingMethod(pagingIndex: pagingIndex, pagingSize: pagingSize))
                    }
                }
            }.resume()
        } else {
            completion(self.pagingMethod(pagingIndex: pagingIndex, pagingSize: pagingSize))
        }
    }
    
    func hasMore() -> Bool {
        return UserDefaults.standard.bool(forKey: "hasMoreData")
    }
    
    private func pagingMethod(pagingIndex: Int, pagingSize: Int) -> [Result] {
        self.sortedResults = iTunesAPIAccess.getAllObjects
        let firstIndex = 20 * pagingIndex
        var lastIndex = 0
        var list: [Result]
        
        if pagingSize < self.sortedResults.count {
            self.hasMoreData = true
            lastIndex = pagingSize
        } else {
            self.hasMoreData = false
            lastIndex = self.sortedResults.count - 1
        }
        
        if firstIndex > lastIndex {
            list = []
        } else {
            list = Array(self.sortedResults[0..<lastIndex])
        }
        
        UserDefaults.standard.set(self.hasMoreData, forKey: "hasMoreData")
        return list
    }
    
    static func saveAllObjects(allObjects: [Result]) {
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(allObjects){
            UserDefaults.standard.set(encoded, forKey: "sortedResult")
        }
    }
}
