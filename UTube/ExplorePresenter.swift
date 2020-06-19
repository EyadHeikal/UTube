//
//  ExplorePresenter.swift
//  UTube
//
//  Created by Eyad Heikal on 6/18/20.
//  Copyright © 2020 Eyad Heikal. All rights reserved.
//

import Foundation
import RxSwift

class ExplorePresenter: NSObject, ExplorePresenterProtocol {
    
    weak var view: ExploreView?
    
    init(_ view: ExploreView) {
        self.view = view
    }
    
    var dataDict: Variable<[QueryResult]> = Variable([])
    let disposeBag = DisposeBag()
    
    func getSearchResults() -> Variable<[QueryResult]> {
        
        //Network.shared.getSearchResults(queryText: queryText)
        Network.shared.dataDict4.asObservable().subscribe(onNext:{ value in
            self.dataDict.value = Network.shared.dataDict4.value
            }).disposed(by: disposeBag)
        return dataDict
    }
    
}


extension ExploreVC: ExploreView {
    
    func setupTableView() {
    }

}
