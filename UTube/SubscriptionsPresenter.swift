//
//  SubscriptionsPresenter.swift
//  UTube
//
//  Created by Eyad Heikal on 6/13/20.
//  Copyright © 2020 Eyad Heikal. All rights reserved.
//

import Foundation
import RxSwift

class SubscriptionsPresenter: NSObject, SubscripotionsPresenterProtocol {
    
    weak var view: SubscriptionsView?
    
    init(_ view: SubscriptionsView) {
        self.view = view
    }
    
    var dataDict: Variable<[Channel]> = Variable([])
    let disposeBag = DisposeBag()
    
    func getChannels() {
        Network.shared.getChannels()
        Network.shared.dataDict3.asObservable().subscribe(onNext:{ value in
            self.dataDict.value = Network.shared.dataDict3.value
            }).disposed(by: disposeBag)
        view?.setupTableView()
    }
    
}


extension SubscriptionsVC: SubscriptionsView {
    
    func setupTableView() {

        self.present?.dataDict.asObservable().bind(to: tableView.rx.items(cellIdentifier: "subcell")){row, element, cell in

            cell.textLabel?.text = self.present?.dataDict.value[row].title
        }.disposed(by: disposeBag)
            
        
    }
    
}
