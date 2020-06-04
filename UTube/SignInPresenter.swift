//
//  SignInPresenter.swift
//  UTube
//
//  Created by Eyad Heikal on 6/1/20.
//  Copyright © 2020 Eyad Heikal. All rights reserved.
//

import Foundation
import GoogleAPIClientForREST
import GoogleSignIn

class SignInPresenter : SingInPresenterProtocol{
    
    weak var view: SignInVC?
    //private let service = Service()
    private let scopes = [kGTLRAuthScopeYouTubeReadonly, kGTLRAuthScopeYouTubeYoutubepartnerChannelAudit]

    private let service = GTLRYouTubeService()
    
    
    init(_ view: SignInVC?) {
        self.view = view
    }
    
    func Login() {
        
    }
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!,
              withError error: Error!) {
        if let error = error {
            showAlert(title: "Authentication Error", message: error.localizedDescription)
            self.service.authorizer = nil
        } else {
            self.view?.signInButton.isHidden = true
            self.view?.output.isHidden = false
            self.service.authorizer = user.authentication.fetcherAuthorizer()
            fetchChannelResource()
        }
    }


    // List up to 10 files in Drive
    func fetchChannelResource() {
        let query = GTLRYouTubeQuery_ChannelsList.query(withPart: "snippet,statistics")
        query.identifier = "UCBJycsmduvYEL83R_U4JriQ"//"UC_x5XG1OV2P6uZZ5FSM9Ttw"
        // To retrieve data for the current user's channel, comment out the previous
        // line (query.identifier ...) and uncomment the next line (query.mine ...)
        // query.mine = true
        service.executeQuery(query,
                             delegate: self,
                             didFinish: #selector(displayResultWithTicket(ticket:finishedWithObject:error:)))
        
        let query2 = GTLRYouTubeQuery_VideosList.query(withPart: "snippet,contentDetails,statistics")
        query2.chart = "mostPopular"
        service.executeQuery(query2, delegate: self, didFinish: #selector(displayResultWithTicket2(ticket:finishedWithObject:error:)))
    }
    
    

    // Process the response and display output
    @objc func displayResultWithTicket(
        ticket: GTLRServiceTicket,
        finishedWithObject response : GTLRYouTube_ChannelListResponse,
        error : NSError?) {

        if let error = error {
            showAlert(title: "Error", message: error.localizedDescription)
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
        view?.output.text = outputText
    }

    @objc func displayResultWithTicket2(
        ticket: GTLRServiceTicket,
        finishedWithObject response : GTLRYouTube_VideoListResponse,
        error : NSError?) {

        if let error = error {
            showAlert(title: "Error", message: error.localizedDescription)
            return
        }
        
        print(response.items?.description as Any)
        view?.output.text = response.items?.description


    }

    // Helper for showing an alert
    func showAlert(title : String, message: String) {
        let alert = UIAlertController(
            title: title,
            message: message,
            preferredStyle: UIAlertController.Style.alert
        )
        let ok = UIAlertAction(
            title: "OK",
            style: UIAlertAction.Style.default,
            handler: nil
        )
        alert.addAction(ok)
        view?.present(alert, animated: true, completion: nil)
    }
    
    
    
}

extension SignInVC : SignInView, GIDSignInDelegate, GIDSignInUIDelegate {
    
}
