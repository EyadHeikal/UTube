//
//  Network.swift
//  UTube
//
//  Created by Eyad Heikal on 6/2/20.
//  Copyright © 2020 Eyad Heikal. All rights reserved.
//

import Foundation
import GoogleAPIClientForREST
import RxSwift
import RxCocoa

class Network: NSObject {
    static let shared = Network()
    private override init() {
        
    }
    
    let service = GTLRYouTubeService()
    let scopes = [kGTLRAuthScopeYouTubeReadonly, kGTLRAuthScopeYouTubeYoutubepartnerChannelAudit]
    
    //private var channelImage: String = ""
    
    //var channelImage: Variable<[String]> = Variable([])
    var channelImage: String = ""//Variable<[String]> = Variable([])

//    func getChannelImageURL(id: String) -> String {
//
//        getChannelImage(id: id)
//
//        return channelImage.value
//    }
    
    func getChannelImage(id: String) {
        let query = GTLRYouTubeQuery_ChannelsList.query(withPart: "snippet,contentDetails,statistics")
        query.identifier = id
        service.executeQuery(query, delegate: self, didFinish: #selector(displayResultWithTicket(ticket:finishedWithObject:error:)))
    }
    
    @objc func displayResultWithTicket(ticket: GTLRServiceTicket, finishedWithObject response : GTLRYouTube_ChannelListResponse, error : NSError?) {
        
        if let error = error {
            //showAlert(title: "Error", message: error.localizedDescription)
            print(error)
            return
        }

        channelImage = (response.items?[0].snippet?.thumbnails?.defaultProperty?.url)!
        //print(channelImage)
    }
    

}
