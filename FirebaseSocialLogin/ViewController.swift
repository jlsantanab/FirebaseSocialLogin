//
//  ViewController.swift
//  FirebaseSocialLogin
//
//  Created by Juan Luis on 3/27/17.
//  Copyright © 2017 Juan Luis. All rights reserved.
//

import UIKit
import FBSDKLoginKit
import Firebase
import FirebaseAuth
import GoogleSignIn

class ViewController: UIViewController, FBSDKLoginButtonDelegate, GIDSignInUIDelegate{

    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupFacebookButtons()
        
        setupGoogleButtons()
        
        
    }
    
    fileprivate func setupGoogleButtons(){
        let googleButton = GIDSignInButton()
        googleButton.frame = CGRect(x: 16, y: 116 + 66, width: view.frame.width - 32, height: 50)
        view.addSubview(googleButton)
        GIDSignIn.sharedInstance().uiDelegate = self
        
        let googleCustomButton = UIButton(type: .system)
        googleCustomButton.frame = CGRect(x: 16, y: 116 + 66 + 66, width: view.frame.width - 32, height: 50)
        googleCustomButton.backgroundColor = .red
        googleCustomButton.setTitle("Custom Google Login Button", for: .normal)
        googleCustomButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        googleCustomButton.setTitleColor(.white, for: .normal)
        googleCustomButton.addTarget(self, action: #selector(handleGoogleCustomButton), for: .touchUpInside)
        view.addSubview(googleCustomButton)
    }
    
    func handleGoogleCustomButton(){
        GIDSignIn.sharedInstance().signIn()
    }
    
    fileprivate func setupFacebookButtons () {
        let loginButton = FBSDKLoginButton()
        view.addSubview(loginButton)
        //frame's are obselete, please use constraints instead because its 2016 after all
        loginButton.frame = CGRect(x: 16, y: 50, width: view.frame.width - 32, height: 50)
        loginButton.delegate = self
        loginButton.readPermissions = ["email", "public_profile"]
        
        let customFBLoginButton = UIButton(type: .system)
        customFBLoginButton.backgroundColor = .blue
        customFBLoginButton.setTitle("Custom FB Login Button", for: .normal)
        customFBLoginButton.frame = CGRect(x: 16, y: 116, width: view.frame.width - 32, height: 50)
        customFBLoginButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        customFBLoginButton.setTitleColor(.white, for: .normal)
        view.addSubview(customFBLoginButton)
        
        customFBLoginButton.addTarget(self, action: #selector(handledCustomFBLoginButton), for: .touchUpInside)
    }
    
    
    func handledCustomFBLoginButton() {
        
          FBSDKLoginManager().logIn(withReadPermissions: ["email", "public_profile" ], from: self) { (result, err) in
            if err != nil {
                print("failed to login with Custom Button", err ?? "")
                return
            }
            
            self.showResult()
            
        }
    }
    func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!) {
        print("Did log out of facebook")
    }
    
    func loginButton(_ loginButton: FBSDKLoginButton!, didCompleteWith result: FBSDKLoginManagerLoginResult!, error: Error!) {
        if error != nil {
            print(error)
            return
        }
        
        print("Successfully logged in with facebook...")
        showResult()
    }
    
    func showResult() {
        
    let accessToken = FBSDKAccessToken.current()
        
        guard let accessTokenString = accessToken?.tokenString! else {return}
        
    let credential = FIRFacebookAuthProvider.credential(withAccessToken: accessTokenString)
        
    FIRAuth.auth()?.signIn(with: credential, completion: { (user, error) in
        if error != nil {
            print("failes", error ?? "")
            return
        }
        
        
    })
        
        FBSDKGraphRequest.init(graphPath: "/me", parameters: ["fields":"id,name,email"]).start(completionHandler: { (connection, result, err) in
            
            if err != nil {
                print("failed to start facebook graph request", err ?? "")
                return
            }
            
            print(result ?? "")
        })
    }
}

