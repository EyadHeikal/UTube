//
//  SignInVC.swift
//  UTube
//
//  Created by Eyad Heikal on 6/1/20.
//  Copyright © 2020 Eyad Heikal. All rights reserved.
//

import GoogleAPIClientForREST
import GoogleSignIn
import UIKit
//import youtube_ios_player_helper

class SignInVC: UIViewController {

    
    // If modifying these scopes, delete your previously saved credentials by
    // resetting the iOS simulator or uninstall the app.
    private let scopes = [kGTLRAuthScopeYouTubeReadonly, kGTLRAuthScopeYouTubeYoutubepartnerChannelAudit]

    //private let service = GTLRYouTubeService()
    let signInButton = GIDSignInButton()
    let output = UITextView()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.isModalInPresentation = true

        // Configure Google Sign-in.
        GIDSignIn.sharedInstance().delegate = self
        GIDSignIn.sharedInstance().uiDelegate = self
        GIDSignIn.sharedInstance().scopes = scopes
        GIDSignIn.sharedInstance().signInSilently()

        // Add the sign-in button.
        view.addSubview(signInButton)

        // Add a UITextView to display output.
        output.frame = view.bounds
        output.isEditable = false
        output.contentInset = UIEdgeInsets(top: 20, left: 0, bottom: 20, right: 0)
        output.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        output.isHidden = true
        view.addSubview(output)
        
    }

    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!,
              withError error: Error!) {
        if let error = error {
            showAlert(title: "Authentication Error", message: error.localizedDescription)
            Network.shared.service.authorizer = nil
        } else {
            self.signInButton.isHidden = true
            self.output.isHidden = false
            Network.shared.service.authorizer = user.authentication.fetcherAuthorizer()
            fetchChannelResource()
            
            //let home = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "Home") as? HomeVC
            //home?.service = GTLRYouTubeService()
            //home?.service?.authorizer = user.authentication.fetcherAuthorizer()
            //self.navigationController?.pushViewController(home!, animated: true)
            
            performSegue(withIdentifier: "SignInSuccess", sender: self)
            //present(home!, animated: true, completion: nil)
            //let tabed = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(identifier: "tab") as? TabVC
            //tabed?.navigationController?.isModalInPresentation = true
            //present(tabed!, animated: true)
            print("Fuck")

        }
    }

    // List up to 10 files in Drive
    func fetchChannelResource() {
        let query = GTLRYouTubeQuery_ChannelsList.query(withPart: "snippet,statistics")
        query.identifier = "UCBJycsmduvYEL83R_U4JriQ"//"UC_x5XG1OV2P6uZZ5FSM9Ttw"
        // To retrieve data for the current user's channel, comment out the previous
        // line (query.identifier ...) and uncomment the next line (query.mine ...)
        // query.mine = true
        Network.shared.service.executeQuery(query,
                             delegate: self,
                             didFinish: #selector(displayResultWithTicket(ticket:finishedWithObject:error:)))
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
        output.text = outputText
    }
    
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
        present(alert, animated: true, completion: nil)
    }


}
