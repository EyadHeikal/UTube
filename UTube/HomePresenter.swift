//
//  HomePresenter.swift
//  UTube
//
//  Created by Eyad Heikal on 6/26/20.
//  Copyright © 2020 Eyad Heikal. All rights reserved.
//

import Foundation
import RxSwift

class HomePresenter: NSObject, HomePresenterProtocol {
    
    weak var view: HomeView?
    
    init(_ view: HomeView) {
        self.view = view
    }
    
    var dataDict: Variable<[Video]> = Variable([])
    let disposeBag = DisposeBag()
    
    func getVideos() {
        Network.shared.getHomeVideos()
        Network.shared.dataDict.asObservable().subscribe(onNext:{ value in
            self.dataDict.value = Network.shared.dataDict.value
            }).disposed(by: disposeBag)
        view?.setupTableView()
    }
    
}


extension HomeVC: HomeView {
    
    func setupTableView() {

        self.present?.dataDict.asObservable().bind(to: homeTableView.rx.items(cellIdentifier: "MyCell")){row, element, cell in
            let cell = cell as? VideoCell
            cell?.chanalImage.sd_setImage(with: URL(string: (self.present?.dataDict.value[row].channelimage)!), completed: nil)
            cell?.videoTitle.text = Network.shared.dataDict.value[row].title
            cell?.videoImage.sd_setImage(with: URL(string: (self.present?.dataDict.value[row].image)!), completed: nil)
        }.disposed(by: disposeBag)
        
        homeTableView.rx.itemSelected
        .subscribe(onNext: { [weak self] indexPath in
          //let cell = self?.homeTableView.cellForRow(at: indexPath)
          //cell.button.isEnabled = false
            print("123")
            let videoView = UIView(frame: self!.view.frame)
            videoView.backgroundColor = UIColor.red
            videoView.frame   = CGRect(x: self!.view.frame.width - 10, y: self!.view.frame.height - 60 , width: 10, height: 10)
            
            let videoPlayerFrame = CGRect(x: 0, y: 0, width: self!.view.frame.size.width, height: self!.view.frame.size.width * 9 / 16)
            let videoPlayer = VideoView(frame: videoPlayerFrame)
            
            videoView.addSubview(videoPlayer)
            
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                videoView.frame = self!.view.frame
                
            }) { (Bool) in
                self?.tabBarController?.tabBar.isHidden = true
                
            }
            
            self?.view.addSubview(videoView)
        }).disposed(by: disposeBag)
        
    }
    
}
