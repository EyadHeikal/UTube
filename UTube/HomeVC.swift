//
//  HomeVC.swift
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

class HomeVC: UIViewController, UICollectionViewDelegate {

    @IBOutlet weak var homeTableView: UITableView!
    
    var disposeBag = DisposeBag()
    var videosArray: Variable<[GTLRYouTube_Video]> = Variable([])

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        homeTableView.register(UINib(nibName: "VideoCell", bundle: nil), forCellReuseIdentifier: "MyCell")
        
        homeTableView.rx.setDelegate(self).disposed(by: disposeBag)
        
        videosArray.asObservable().bind(to: homeTableView.rx.items(cellIdentifier: "MyCell")){row, element, cell in
            print(element)
            
            let id = self.videosArray.value[row].identifier
            let cell = cell as! VideoCell
            //cell.textLabel?.text = self.videosArray.value[row] as? String
            var url = URL(string: "https://img.youtube.com/vi/\(id ?? "Eyad")/0.jpg")
            cell.videoImage.sd_setImage(with: url, placeholderImage: nil, context: nil)
            cell.videoTitle.text = self.videosArray.value[row].snippet?.title
            if let channelID = self.videosArray.value[row].snippet?.channelId
            {
//                Network.shared.channelImage.asObservable().subscribe(onNext:{ str in
//                    Network.shared.getChannelImage(id: channelID)
//                    url = URL(string: Network.shared.channelImage.value[row])
//                    cell.chanalImage.sd_setImage(with: url, placeholderImage: nil, context: nil)
//                }).disposed(by: self.disposeBag)
                
                Network.shared.getChannelImage(id: channelID)
                url = URL(string: Network.shared.channelImage)
                print(url as Any)
                cell.chanalImage.sd_setImage(with: url, placeholderImage: nil, context: nil)
                
            }
            
            
            
        }.disposed(by: self.disposeBag)
        
        
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
        
        //videosArray.value = ["Eyad","Anas"]
        print("Home")
        fetchChannelResource()
        // Do any additional setup after loading the view.
    }
    
    
    func fetchChannelResource() {
        let query = GTLRYouTubeQuery_VideosList.query(withPart: "snippet,contentDetails,statistics")
        query.chart = "mostPopular"

        Network.shared.service.executeQuery(query,
                             delegate: self,
                             didFinish: #selector(displayResultWithTicket(ticket:finishedWithObject:error:)))
    }
    
    

    // Process the response and display output
    @objc func displayResultWithTicket(
        ticket: GTLRServiceTicket,
        finishedWithObject response : GTLRYouTube_VideoListResponse,
        error : NSError?) {

        if error != nil {
            //showAlert(title: "Error", message: error.localizedDescription)
            print("Error")
            return
        }

        var outputText = ""
        if let channels = response.items, !channels.isEmpty {
            let channel = response.items![0]
            let title = channel.snippet!.title
            let description = channel.snippet?.descriptionProperty
            let viewCount = channel.statistics?.viewCount
            outputText += "title: \(title!)\n"
            outputText += "description: \(description!)\n"
            outputText += "view count: \(viewCount!)\n"
        }        //output.text = outputText
        videosArray.value = response.items!

        print(outputText)
        print("Success")
        print(response.items?[0].snippet?.thumbnails?.defaultProperty?.url as Any)


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
