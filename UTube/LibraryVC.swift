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

    override func viewDidLoad() {
        super.viewDidLoad()
        print("Library")
        fetchChannelResource()
        // Do any additional setup after loading the view.
    }
    
    func fetchChannelResource() {
        let query = GTLRYouTubeQuery_VideosList.query(withPart: "snippet,contentDetails,statistics")
        //query.identifier = "UCBJycsmduvYEL83R_U4JriQ"//"UC_x5XG1OV2P6uZZ5FSM9Ttw"
        //query.mine = true
        query.myRating = "like."
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
        finishedWithObject response : GTLRYouTube_VideoListResponse,
        error : NSError?) {

        if let error = error {
            //showAlert(title: "Error", message: error.localizedDescription)
            print(error)
            return
        }

//            var outputText = "NULL"
//            if let channels = response.items, !channels.isEmpty {
//                let channel = response.items![0]
//                let title = channel.snippet!.title
//                let description = channel.snippet?.descriptionProperty
//                //let viewCount = channel.statistics?.viewCount
//                outputText += "title: \(title!)\n"
//                outputText += "description: \(description!)\n"
//                //outputText += "view count: \(viewCount!)\n"
//            }
        //output.text = outputText
        print(response.items?[0].snippet?.title)
        print(response.items?[1].snippet?.title)
        print(response.items?[2].snippet?.title)

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
