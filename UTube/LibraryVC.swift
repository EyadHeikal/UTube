//
//  LibraryVC.swift
//  UTube
//
//  Created by Eyad Heikal on 6/2/20.
//  Copyright © 2020 Eyad Heikal. All rights reserved.
//

import UIKit
import GoogleAPIClientForREST
import RxSwift
import SDWebImage

class LibraryVC: UIViewController, UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    
    var present: LibraryPresenter?
    
    let disposeBag = DisposeBag()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("Library")

        tableView.register(UINib(nibName: "VideoCell", bundle: nil), forCellReuseIdentifier: "MyCell")
        tableView.rx.setDelegate(self).disposed(by: disposeBag)
        
        present = LibraryPresenter(self)
        present?.getVideos()
        
        
        // Do any additional setup after loading the view.
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
