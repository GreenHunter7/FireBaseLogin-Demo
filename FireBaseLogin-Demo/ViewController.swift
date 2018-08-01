//
//  ViewController.swift
//  FireBaseLogin-Demo
//
//  Created by Mohamed Hussien on 01/08/2018.
//  Copyright © 2018 Mohamed Hussien. All rights reserved.
//

import UIKit
import Firebase
import FirebaseUI
import FBSDKCoreKit
import FBSDKLoginKit
import GoogleSignIn
import TwitterKit

class ViewController: UIViewController,FUIAuthDelegate,FBSDKLoginButtonDelegate,GIDSignInDelegate,GIDSignInUIDelegate {
    
    let authUI = FUIAuth.defaultAuthUI()
    
    let providers: [FUIAuthProvider] = [
        FUIGoogleAuth(),
        FUIFacebookAuth(),
        FUITwitterAuth(),
        FUIPhoneAuth(authUI: FUIAuth.defaultAuthUI()!),
        ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        GIDSignIn.sharedInstance().clientID = FirebaseApp.app()?.options.clientID
        GIDSignIn.sharedInstance().delegate = self
        GIDSignIn.sharedInstance().uiDelegate = self
        
        authUI?.delegate = self
        let loginButton = FBSDKLoginButton()
        loginButton.delegate = self
        
        self.authUI?.providers = providers
        
        //Twitter
        let twitterlogInButton = TWTRLogInButton(logInCompletion: { session, error in
            if (session != nil) {
                let authToken = session?.authToken
                let authTokenSecret = session?.authTokenSecret
                // ...
                let credential = TwitterAuthProvider.credential(withToken: authToken!, secret: authTokenSecret!)
                Auth.auth().signInAndRetrieveData(with: credential) { (authResult, error) in
                    if let error = error {
                        // ...
                        return
                    }
                    // User is signed in
                    // ...
                }
            } else {
                // ...
            }
        })
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func signInTapped(_ sender: Any){
        let authViewController = authUI?.authViewController()
        present(authViewController!, animated: true, completion: nil)
    }

    //MARK:-
    
    //firebaseUI
    
    
    
    func authUI(_ authUI: FUIAuth, didSignInWith user: User?, error: Error?) {
        // handle user and error as necessary
        if error != nil{
            print(error!)
        }else{
            print(user!)
        }
    }
    
    //facebook sdk delegate
    func loginButton(_ loginButton: FBSDKLoginButton!, didCompleteWith result: FBSDKLoginManagerLoginResult!, error: Error!) {
        let credential = FacebookAuthProvider.credential(withAccessToken: FBSDKAccessToken.current().tokenString)
        Auth.auth().signInAndRetrieveData(with: credential) { (authResult, error) in
            if let error = error {
                // ...
                return
            }
            // User is signed in
            // ...
        }

    }
    
    func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!) {
        let firebaseAuth = Auth.auth()
        do {
            try firebaseAuth.signOut()
        } catch let signOutError as NSError {
            print ("Error signing out: %@", signOutError)
        }
    }
    
    //google signin delehate
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        
        if let error = error {
            // ...
            return
        }
        
        guard let authentication = user.authentication else { return }
        let credential = GoogleAuthProvider.credential(withIDToken: authentication.idToken,
                                                       accessToken: authentication.accessToken)
        Auth.auth().signInAndRetrieveData(with: credential) { (authResult, error) in
            if let error = error {
                // ...
                return
            }
            // User is signed in
            // ...
        }
    }
    
    //twitter signin delegate
    
    
    

}

