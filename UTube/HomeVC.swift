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

class HomeVC: UIViewController, UICollectionViewDelegate {

    @IBOutlet weak var homeTableView: UITableView!
    
    var disposeBag = DisposeBag()
    var moviesArray: Variable<[Any]> = Variable([])

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        homeTableView.register(UINib(nibName: "VideoCell", bundle: nil), forCellReuseIdentifier: "MyCell")
        
        homeTableView.rx.setDelegate(self).disposed(by: disposeBag)
        
        moviesArray.asObservable().bind(to: homeTableView.rx.items(cellIdentifier: "MyCell")){row, element, cell in
            print(element)
            //cell.textLabel = self.moviesArray.value[row]
            let cell = cell as! VideoCell
            cell.textLabel?.text = self.moviesArray.value[row] as? String
        }.disposed(by: self.disposeBag)
        
        moviesArray.value = ["Eyad","Anas"]
        print("Home")
        fetchChannelResource()
        // Do any additional setup after loading the view.
    }
    
    
    func fetchChannelResource() {
        let query = GTLRYouTubeQuery_ChannelsList.query(withPart: "snippet,statistics")
        query.identifier = "UCBJycsmduvYEL83R_U4JriQ"//"UC_x5XG1OV2P6uZZ5FSM9Ttw"
        // To retrieve data for the current user's channel, comment out the previous
        // line (query.identifier ...) and uncomment the next line (query.mine ...)
        // query.mine = true
        Network.service.executeQuery(query,
                             delegate: self,
                             didFinish: #selector(displayResultWithTicket(ticket:finishedWithObject:error:)))
    }
    
    

    // Process the response and display output
    @objc func displayResultWithTicket(
        ticket: GTLRServiceTicket,
        finishedWithObject response : GTLRYouTube_ChannelListResponse,
        error : NSError?) {

        if let error = error {
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
        }
        //output.text = outputText
        print(outputText)

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
