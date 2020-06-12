//
//  LibraryPresenter.swift
//  UTube
//
//  Created by Eyad Heikal on 6/11/20.
//  Copyright © 2020 Eyad Heikal. All rights reserved.
//

import Foundation

class LibraryPresenter: NSObject, LibraryPresenterProtocol {
    
    weak var view: LibraryView?
    
    init(_ view: LibraryView) {
        self.view = view
    }
    
    var dataDict: [Video] = []
    
    func getVideos() {
        Network.shared.getLikedVideos()
    }
    
}


extension LibraryVC: LibraryView {
    
}
