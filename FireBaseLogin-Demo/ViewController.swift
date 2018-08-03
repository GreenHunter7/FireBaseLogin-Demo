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
import GoogleSignIn
import TwitterKit


class ViewController: UIViewController,FUIAuthDelegate,GIDSignInDelegate,GIDSignInUIDelegate {
    
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var containerStackView: UIStackView!
    
    
    let authUI = FUIAuth.defaultAuthUI()
    let providers: [FUIAuthProvider] = [FUIGoogleAuth(),
                                        FUITwitterAuth()]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initialSetup()
    }
    
    func initialSetup(){
        GIDSignIn.sharedInstance().uiDelegate = self
        
        authUI?.delegate = self
        
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
        //Google
        let googleSignInBtn = GIDSignInButton()
        
        //emailSignin
        let emailSignInBtn = UIButton()
        emailSignInBtn.backgroundColor = #colorLiteral(red: 0.8078431373, green: 0.03921568627, blue: 0.1411764706, alpha: 1)
        //emailSignInBtn.setImage(#imageLiteral(resourceName: "gmail"), for: .normal)
        emailSignInBtn.setAttributedTitle(attreibutedString(string: "Signin with email"), for: .normal)
        emailSignInBtn.addTarget(self, action: #selector(emailSignInTapped(_:)), for: .touchUpInside)
        
        containerStackView.addArrangedSubview(twitterlogInButton)
        containerStackView.addArrangedSubview(googleSignInBtn)
        containerStackView.addArrangedSubview(emailSignInBtn)
        
        //=======
        
    }
    
    func attreibutedString(string: String) -> NSAttributedString{
        var attrbutes = [NSAttributedStringKey : Any]()
        let font = UIFont(name: "Arial-Medium", size: 14)
        attrbutes[NSAttributedStringKey.font] = font
        
        attrbutes[NSAttributedStringKey.foregroundColor] = UIColor.white
        let atrStr = NSAttributedString(string: "Signin With Email", attributes: attrbutes)
        return atrStr
    }

    @objc func emailSignInTapped(_ sender: UIButton){
        let vc = FUIEmailEntryViewController(authUI: authUI!)
        let nvc = authUI?.authViewController()
        nvc?.viewControllers.removeAll()
        nvc?.viewControllers = [vc]
        present(nvc!, animated: true, completion: nil)
    }
    
    @IBAction func signInTapped(_ sender: Any){
        //let authViewController = authUI?.authViewController()
    }

    //MARK:-
    
    //firebaseUI
    
    func authPickerViewController(forAuthUI authUI: FUIAuth) -> FUIAuthPickerViewController {
        let customController = CustomAuthViewController(authUI: authUI)
        let backgroundImg = UIImageView(image: #imageLiteral(resourceName: "login_background"))
        backgroundImg.contentMode = .scaleAspectFill
        backgroundImg.frame.origin = CGPoint(x: 0, y: 0)
        backgroundImg.frame.size.height = view.frame.size.height
        backgroundImg.frame.size.width = view.frame.size.width
        customController.view.addSubview(backgroundImg)
        customController.view.sendSubview(toBack: backgroundImg)
        return customController
    }
    
    
    func authUI(_ authUI: FUIAuth, didSignInWith user: User?, error: Error?) {
        // handle user and error as necessary
        if error != nil{
            print(error!)
        }else{
            print(user!)
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

}

