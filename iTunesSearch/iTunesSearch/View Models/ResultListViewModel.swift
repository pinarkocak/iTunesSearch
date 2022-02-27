//
//  ResultListViewModel.swift
//  iTunesSearch
//
//  Created by Pınar Koçak on 25.02.2022.
//

import Foundation

struct ResultListViewModel {
    let results: [Result]
}

extension ResultListViewModel {
    var numberOfSections: Int {
        return getSectionTitle().count
    }
    
    func numberOfRowsInSection(_ section: Int) -> Int {
        return self.results.filter{ $0.wrapperType == getSectionTitle()[section] }.count
    }
    
    func resultAtIndex(_ index: Int, _ section: Int) -> ResultViewModel {
        let array = self.results.filter{ $0.wrapperType == getSectionTitle()[section] }
        let results = array[index]
        return ResultViewModel(results)
    }
    
    func getCount() -> Int {
        return self.results.count
    }
    
    func getSectionTitle() -> [String] {
        var wrapperTypeList: [String] = []
        results.forEach { item in
            if wrapperTypeList.count == 0 {
                wrapperTypeList.append(item.wrapperType ?? "")
            }
            else if wrapperTypeList.count > 0 && !wrapperTypeList.contains(item.wrapperType ?? "") {
                wrapperTypeList.append(item.wrapperType ?? "")
            }
        }
    
        return wrapperTypeList
    }
}
