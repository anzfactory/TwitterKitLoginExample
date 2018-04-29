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
    
    private let button: UIButton = UIButton(type: .system)
    private let label: UILabel = UILabel(frame: .zero)

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
        
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = ""
        label.font = .boldSystemFont(ofSize: 18.0)
        self.view.addSubview(label)
        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            label.centerYAnchor.constraint(equalTo: self.view.centerYAnchor)
        ])
        
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("ログアウト", for: .normal)
        button.addTarget(self, action: #selector(type(of: self).logout), for: .touchUpInside)
        self.view.addSubview(button)
        NSLayoutConstraint.activate([
            button.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -16.0),
            button.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -16.0)
        ])
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if let session = TWTRTwitter.sharedInstance().sessionStore.session() {
            label.text = session.userID
        } else {
            TWTRTwitter.sharedInstance().logIn { (session, error) in
                if let error = error {
                    print(error)
                }
            }
        }
    }

    
    @objc private func logout() {
        guard let sessions = TWTRTwitter.sharedInstance().sessionStore.existingUserSessions() as? [TWTRSession] else {
            return
        }
        
        for session in sessions {
            TWTRTwitter.sharedInstance().sessionStore.logOutUserID(session.userID)
        }
    }
}
