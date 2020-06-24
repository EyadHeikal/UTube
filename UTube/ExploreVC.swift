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
        
        
        textField.rx.text.orEmpty.debounce(.seconds(1), scheduler: MainScheduler.instance).map({ (text)  in
            return text
        }).subscribe(onNext: {
            if $0 == "" {
                Network.shared.dataDict4.value = []
            }
            else {
                Network.shared.getSearchResults(queryText: $0)
            }
        }).disposed(by: disposeBag)
        
        Network.shared.dataDict4.asObservable().bind(to: tableView.rx.items(cellIdentifier: "explorecell")){row, element, cell in

             cell.textLabel?.text = Network.shared.dataDict4.value[row].title
         }.disposed(by: disposeBag)
            

    }
            

}
