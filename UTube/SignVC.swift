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

class SignVC: UIViewController, UIAdaptivePresentationControllerDelegate, GIDSignInDelegate, GIDSignInUIDelegate {


    //private let service = GTLRYouTubeService()
    let signInButton = GIDSignInButton()
    let output = UITextView()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Configure Google Sign-in.
        GIDSignIn.sharedInstance().delegate = self
        GIDSignIn.sharedInstance().uiDelegate = self
        GIDSignIn.sharedInstance().scopes = Network.shared.scopes
        GIDSignIn.sharedInstance().signInSilently()

        // Add the sign-in button.
        view.addSubview(signInButton)

        
    }

    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!,
              withError error: Error!) {
        if error != nil {
            Network.shared.service.authorizer = nil
        } else {
            self.signInButton.isHidden = true
            self.output.isHidden = false
            Network.shared.service.authorizer = user.authentication.fetcherAuthorizer()
            
            let tabed = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(identifier: "tab") as? TabVC
            tabed?.modalPresentationStyle = .fullScreen
            navigationController!.present(tabed!, animated: true, completion: nil)


        }
    }




}
