//
//  SubscriptionsVC.swift
//  UTube
//
//  Created by Eyad Heikal on 6/2/20.
//  Copyright © 2020 Eyad Heikal. All rights reserved.
//

import UIKit
import GoogleAPIClientForREST
import RxSwift
import SDWebImage

class SubscriptionsVC: UIViewController, UITableViewDelegate {

    @IBOutlet weak var tableView: UITableView!
    
    var present: SubscriptionsPresenter?
    
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("Subscriptions")
        //UINib(nibName: "ChannelCell", bundle: nil)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "subcell")
        tableView.rx.setDelegate(self).disposed(by: disposeBag)
        
        present = SubscriptionsPresenter(self)
        present?.getChannels()
        // Do any additional setup after loading the view.
    }


}
