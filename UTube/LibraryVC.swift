//
//  LibraryVC.swift
//  UTube
//
//  Created by Eyad Heikal on 6/2/20.
//  Copyright © 2020 Eyad Heikal. All rights reserved.
//

import UIKit
import GoogleAPIClientForREST

class LibraryVC: UIViewController {

    var present: LibraryPresenter?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        present = LibraryPresenter(self)
        present?.getVideos()
        print("Library")
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
