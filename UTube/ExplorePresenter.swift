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
    
    func getSearchResults(query: String) -> Variable<[QueryResult]> {
        
        //Network.shared.getSearchResults(queryText: queryText)
//        Network.shared.dataDict4.asObservable().subscribe(onNext:{ value in
//            self.dataDict.value = Network.shared.dataDict4.value
//            }).disposed(by: disposeBag)
        
        Network.shared.getSearchResults(queryText: query)
        dataDict.value = Network.shared.dataDict4.value
        return dataDict
    }
    
}


extension ExploreVC: ExploreView {
    
    func setupTableView() {
        
        textField.rx.text.orEmpty.debounce(.seconds(1), scheduler: MainScheduler.instance).map({ (text)  in
            return text
        }).subscribe(onNext: {
            if $0 == "" {
                self.present?.dataDict.value = []
            }
            else {
                self.present?.getSearchResults(query: $0)
            }
        }).disposed(by: disposeBag)
        
        present?.dataDict.asObservable().bind(to: tableView.rx.items(cellIdentifier: "explorecell")){row, element, cell in

            cell.textLabel?.text = self.present?.dataDict.value[row].title
         }.disposed(by: disposeBag)
        
    }

}
