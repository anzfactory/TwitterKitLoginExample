//
//  ViewController.swift
//  TwitterKitLoginExample
//
//  Created by shingo asato on 2018/04/30.
//  Copyright © 2018年 anz. All rights reserved.
//

import UIKit

import TwitterKit

class ViewController: UIViewController {
    
    private let button: UIButton = {
        
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("ログアウト", for: .normal)
        return button
    }()
    private let label: UILabel = {
        
        let label = UILabel(frame: .zero)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = ""
        label.font = .boldSystemFont(ofSize: 18.0)
        return label
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard
            let consumerKey = Bundle.main.infoDictionary?["TwitterConsumerKey"] as? String,
            let consumerSecret = Bundle.main.infoDictionary?["TwitterConsumerSecret"] as? String,
            !consumerKey.isEmpty,
            !consumerSecret.isEmpty
        else {
            assertionFailure("ConsumerKeyなんかを設定して下さい！")
            return
        }
        
        TWTRTwitter.sharedInstance().start(withConsumerKey: consumerKey, consumerSecret: consumerSecret)
        
        view.addSubview(label)
        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            label.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
        
        button.addTarget(self, action: #selector(type(of: self).tapLogout), for: .touchUpInside)
        view.addSubview(button)
        NSLayoutConstraint.activate([
            button.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -16.0),
            button.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -16.0)
        ])
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        confirm()
    }
}

extension ViewController {
    
    private func confirm() {
        
        if let session = TWTRTwitter.sharedInstance().sessionStore.session() {
            label.text = session.userID
        } else {
            let alert = UIAlertController(title: "Twitter連携", message: nil, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "する", style: .default, handler: { _ in
                self.login()
            }))
            alert.addAction(UIAlertAction(title: "しない", style: .cancel, handler: nil))
            present(alert, animated: true, completion: nil)
        }
    }
    
    private func login() {
        
        TWTRTwitter.sharedInstance().logIn { (session, error) in
            if let error = error {
                print("\n----- Login Error!!! -----\n\(error)\n")
            } else if let session = session {
                self.label.text = session.userID
            }
        }
    }
    
    private func logout() {
        
        if let session = TWTRTwitter.sharedInstance().sessionStore.session() {
            TWTRTwitter.sharedInstance().sessionStore.logOutUserID(session.userID)
        }
        
        if let sessions = TWTRTwitter.sharedInstance().sessionStore.existingUserSessions() as? [TWTRSession] {
            for session in sessions {
                TWTRTwitter.sharedInstance().sessionStore.logOutUserID(session.userID)
            }
        }
        
        label.text = ""
        
    }
}

@objc extension ViewController {
    
    private func tapLogout() {
        
        logout()
        confirm()
    }
}
