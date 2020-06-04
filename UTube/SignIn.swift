//
//  Test.swift
//  UTube
//
//  Created by Eyad Heikal on 6/1/20.
//  Copyright © 2020 Eyad Heikal. All rights reserved.
//

import Foundation
import GoogleSignIn
import GoogleAPIClientForREST

class SingInService {
    // If modifying these scopes, delete your previously saved credentials by
    // resetting the iOS simulator or uninstall the app.
    private let scopes = [kGTLRAuthScopeYouTubeReadonly, kGTLRAuthScopeYouTubeYoutubepartnerChannelAudit]

    private let service = GTLRYouTubeService()
    let signInButton = GIDSignInButton()
    let output = UITextView()
}
