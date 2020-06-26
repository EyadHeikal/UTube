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
    
    var channelImage: String = ""//Variable<[String]> = Variable([])

    var dataDict: Variable<[Video]> = Variable([])

    
    func getHomeVideos() {
        let query = GTLRYouTubeQuery_VideosList.query(withPart: "snippet,contentDetails,statistics")
        query.chart = "mostPopular"
        query.maxResults = 25
        Network.shared.service.executeQuery(query, delegate: self, didFinish: #selector(getHomeVideosS(ticket:finishedWithObject:error:)))
    }
    
    @objc func getHomeVideosS(ticket: GTLRServiceTicket, finishedWithObject response : GTLRYouTube_VideoListResponse, error : NSError?) {
        
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
            dataDict.value.append(video)
            
            i += 1
        }
        //print(channelImage)
        getChannelImage()
    }
    func getChannelImage() {
           let query = GTLRYouTubeQuery_ChannelsList.query(withPart: "snippet,contentDetails,statistics")
           query.identifier = "UCp1mRTkVlqDnxz_9S0YD9YQ"
           
           for x in dataDict.value {
               //if x["channelid"] != nil {
               query.identifier?.append(",\(x.channelid)")//(",\(x["channelid"]!)")
               //}
           }
           service.executeQuery(query, delegate: self, didFinish: #selector(getChannelImageS(ticket:finishedWithObject:error:)))
       }
       
       @objc func getChannelImageS(ticket: GTLRServiceTicket, finishedWithObject response : GTLRYouTube_ChannelListResponse, error : NSError?) {
           
           if let error = error {
               //showAlert(title: "Error", message: error.localizedDescription)
               print(error)
               return
           }
           
           for item in response.items! {
               var i = 0
               while i < dataDict.value.count {//for i in dataDict2.value {
                   if item.identifier == dataDict.value[i].channelid {
                       dataDict.value[i].channelimage = (item.snippet?.thumbnails?.defaultProperty?.url)!
                   }
                   i += 1
               }
           }
           print(dataDict.value)
       }
    ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    
    var dataDict2: Variable<[Video]> = Variable([])

    func getLikedVideos() {
        let query = GTLRYouTubeQuery_VideosList.query(withPart: "snippet,contentDetails,statistics")
        query.myRating = "like"
        query.maxResults = 25
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
        let query = GTLRYouTubeQuery_SubscriptionsList.query(withPart: "snippet,contentDetails,subscriberSnippet")
        query.mine = true
        query.maxResults = 25
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
        var i = 0
        while i < response.items!.count {

            let channel = Channel(id: (response.items?[i].snippet?.resourceId?.channelId)!, title: (response.items?[i].snippet?.title)!)
            //print(response.items?[i].snippet?.resourceId?.channelId as Any)
            dataDict3.value.append(channel)
            
            i += 1
        }
        getChannelImage3()
    }
    
    func getChannelImage3() {
        let query = GTLRYouTubeQuery_ChannelsList.query(withPart: "snippet,contentDetails,statistics")
        query.identifier = "UCp1mRTkVlqDnxz_9S0YD9YQ"
        
        for x in dataDict3.value {
            //if x["channelid"] != nil {
            query.identifier?.append(",\(x.id)")//(",\(x["channelid"]!)")
            //}
        }
        service.executeQuery(query, delegate: self, didFinish: #selector(getChannelImageS3(ticket:finishedWithObject:error:)))
    }
    
    @objc func getChannelImageS3(ticket: GTLRServiceTicket, finishedWithObject response : GTLRYouTube_ChannelListResponse, error : NSError?) {
        
        if let error = error {
            print(error)
            return
        }
        for item in response.items! {
            var i = 0
            while i < dataDict3.value.count {
                //for i in dataDict2.value {
                if item.identifier == dataDict3.value[i].id {
                    dataDict3.value[i].channelimage = (item.snippet?.thumbnails?.defaultProperty?.url)!
                    //print(dataDict3.value[i].channelimage)
                }
                i += 1
            }
        }
        //print(dataDict3.value)
    }
    
    
    ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    var dataDict4: Variable<[QueryResult]> = Variable([])
    
    func getSearchResults(queryText: String) {
        let query = GTLRYouTubeQuery_SearchList.query(withPart: "snippet")
        query.q = queryText
        query.maxResults = 5
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
        dataDict4.value = []
        var i = 0
        while i < response.items!.count {
                        
            let result = QueryResult(title: (response.items?[i].snippet?.title)!)
            dataDict4.value.append(result)
            i += 1
        }
    }
}
