//
//  ExploreVC.swift
//  UTube
//
//  Created by Eyad Heikal on 6/2/20.
//  Copyright © 2020 Eyad Heikal. All rights reserved.
//

import UIKit
import GoogleAPIClientForREST
import RxSwift
import RxCocoa
import SDWebImage

class ExploreVC: UIViewController, UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var textField: UITextField!
    
    var present: ExplorePresenter?
    
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("Explore")
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "explorecell")
        tableView.rx.setDelegate(self).disposed(by: disposeBag)
        
        present = ExplorePresenter(self)
        //present?.getSearchResults(queryText: "Covid 19")
        
        
       let text = textField.rx.text.orEmpty.debounce(.milliseconds(500), scheduler: MainScheduler.instance).flatMap{ (query) -> Observable<[QueryResult]> in
        if query == "" {
            return Observable<[QueryResult]>.just([])
        }
        else {
            Network.shared.getSearchResults(queryText: query)
            return Network.shared.dataDict4.asObservable()//Observable<[QueryResult]>.just([])
        }
        
       }.observeOn(MainScheduler.instance)

        text.bind(to: tableView.rx.items(cellIdentifier: "explorecell")){row, element, cell in

            cell.textLabel?.text = Network.shared.dataDict4.value[row].title
        }.disposed(by: disposeBag)
            
    }
        

}
