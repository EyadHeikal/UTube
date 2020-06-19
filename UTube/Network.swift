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
        service.executeQuery(query, delegate: self, didFinish: #selector(getChannelImageS(ticket:finishedWithObject:error:)))
    }
    
    @objc func getChannelImageS(ticket: GTLRServiceTicket, finishedWithObject response : GTLRYouTube_ChannelListResponse, error : NSError?) {
        
        if let error = error {
            //showAlert(title: "Error", message: error.localizedDescription)
            print(error)
            return
        }

        channelImage = (response.items?[0].snippet?.thumbnails?.defaultProperty?.url)!
        //print(channelImage)
    }
    ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    
    var dataDict2: Variable<[Video]> = Variable([])

    func getLikedVideos() {
        let query = GTLRYouTubeQuery_VideosList.query(withPart: "snippet,contentDetails,statistics")
        query.myRating = "like"
        Network.shared.service.executeQuery(query, delegate: self, didFinish: #selector(getLikedVideosS(ticket:finishedWithObject:error:)))
    }
    
    @objc func getLikedVideosS(ticket: GTLRServiceTicket, finishedWithObject response : GTLRYouTube_VideoListResponse, error : NSError?) {
        
        if let error = error {
            //showAlert(title: "Error", message: error.localizedDescription)
            print(error)
            return
        }
        
        var i = 0
        
        while i < response.items!.count {
            
            let video = Video(id: (response.items?[i].snippet?.title)!,
                              title: (response.items?[i].snippet?.title)!,
                              channelid: (response.items?[i].snippet?.channelId)!,
                              image: "https://img.youtube.com/vi/\(response.items?[i].identifier ?? "Eyad")/0.jpg")
            dataDict2.value.append(video)
            
            i += 1
        }

        getChannelImage2()
        
    }
    
    func getChannelImage2() {
        let query = GTLRYouTubeQuery_ChannelsList.query(withPart: "snippet,contentDetails,statistics")
        query.identifier = "UCp1mRTkVlqDnxz_9S0YD9YQ"
        
        for x in dataDict2.value {
            //if x["channelid"] != nil {
            query.identifier?.append(",\(x.channelid)")//(",\(x["channelid"]!)")
            //}
        }
        service.executeQuery(query, delegate: self, didFinish: #selector(getChannelImageS2(ticket:finishedWithObject:error:)))
    }
    
    @objc func getChannelImageS2(ticket: GTLRServiceTicket, finishedWithObject response : GTLRYouTube_ChannelListResponse, error : NSError?) {
        
        if let error = error {
            //showAlert(title: "Error", message: error.localizedDescription)
            print(error)
            return
        }
        
        for item in response.items! {
            var i = 0
            while i < dataDict2.value.count {//for i in dataDict2.value {
                if item.identifier == dataDict2.value[i].channelid {
                    dataDict2.value[i].channelimage = (item.snippet?.thumbnails?.defaultProperty?.url)!
                }
                i += 1
            }
        }
        
        print(dataDict2.value)
    }
    
    ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

    var dataDict3: Variable<[Channel]> = Variable([])

    func getChannels() {
        let query = GTLRYouTubeQuery_SubscriptionsList.query(withPart: "snippet,contentDetails")
        query.mine = true
        Network.shared.service.executeQuery(query, delegate: self, didFinish: #selector(displayResultWithTicket3(ticket:finishedWithObject:error:)))
    }

    // Process the response and display output
    @objc func displayResultWithTicket3(
        ticket: GTLRServiceTicket,
        finishedWithObject response : GTLRYouTube_SubscriptionListResponse,
        error : NSError?) {

        if let error = error {
            //showAlert(title: "Error", message: error.localizedDescription)
            print(error)
            return
        }

        print(response.items?[0].snippet?.title as Any)
        print(response.items?[1].snippet?.title as Any)
        print(response.items?[2].snippet?.title as Any)
        var i = 0
        
        while i < response.items!.count {
            
            let channel = Channel(title: (response.items?[i].snippet?.title)!)//, channelimage: (response.items?[i].snippet?.thumbnails?.defaultProperty?.url)!)
            
            dataDict3.value.append(channel)
            
            i += 1
        }

    }
    
    ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    var dataDict4: Variable<[QueryResult]> = Variable([])
    
    func getSearchResults(queryText: String) {
        let query = GTLRYouTubeQuery_SearchList.query(withPart: "snippet")
        query.q = queryText
        query.maxResults = 25
        Network.shared.service.executeQuery(query, delegate: self, didFinish: #selector(displayResultWithTicket4(ticket:finishedWithObject:error:)))
    }

    // Process the response and display output
    @objc func displayResultWithTicket4(
        ticket: GTLRServiceTicket,
        finishedWithObject response : GTLRYouTube_SearchListResponse,
        error : NSError?) {

        if let error = error {
            //showAlert(title: "Error", message: error.localizedDescription)
            print(error)
            return
        }
        var i = 0
        while i < response.items!.count {
                        
            let result = QueryResult(title: (response.items?[i].snippet?.title)!)
            dataDict4.value.append(result)
            
            i += 1
        }
    }
}
