//
//  LibraryPresenter.swift
//  UTube
//
//  Created by Eyad Heikal on 6/11/20.
//  Copyright © 2020 Eyad Heikal. All rights reserved.
//

import Foundation
import RxSwift

class LibraryPresenter: NSObject, LibraryPresenterProtocol {
    
    weak var view: LibraryView?
    
    init(_ view: LibraryView) {
        self.view = view
    }
    
    var dataDict: Variable<[Video]> = Variable([])
    let disposeBag = DisposeBag()
    
    func getVideos() {
        Network.shared.getLikedVideos()
        Network.shared.dataDict2.asObservable().subscribe(onNext:{ value in
            self.dataDict.value = Network.shared.dataDict2.value
            }).disposed(by: disposeBag)
        view?.setupTableView()
    }
    
}


extension LibraryVC: LibraryView {
    
    func setupTableView() {

        self.present?.dataDict.asObservable().bind(to: tableView.rx.items(cellIdentifier: "MyCell")){row, element, cell in
            let cell = cell as? VideoCell
            cell?.chanalImage.sd_setImage(with: URL(string: (self.present?.dataDict.value[row].channelimage)!), completed: nil)
            cell?.videoTitle.text = Network.shared.dataDict2.value[row].title
            cell?.videoImage.sd_setImage(with: URL(string: (self.present?.dataDict.value[row].image)!), completed: nil)
        }.disposed(by: disposeBag)
            
        
    }
    
}
