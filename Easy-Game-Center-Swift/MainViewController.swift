//
//  ViewController.swift
//  Easy-Game-Center-Swift
//
//  Created by DaRk-_-D0G on 19/03/2558 E.B..
//  Copyright (c) 2558 ère b. DaRk-_-D0G. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {

    @IBOutlet weak var Name: UILabel!
    @IBOutlet weak var PlayerID: UILabel!
    @IBOutlet weak var PlayerAuthentified: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Easy Game Center"
        
        let eaysGameCenter = EasyGameCenter.sharedInstance {
            (resultPlayerAuthentified) -> Void in
            
            /* Player conected to Game Center */
            if resultPlayerAuthentified {
                
                self.PlayerID.text = "Player ID : \(EasyGameCenter.getLocalPlayer().playerID)"
                
                self.Name.text = "Name : \(EasyGameCenter.getLocalPlayer().alias)"
                
            /* Player NOT conected to Game Center */
            } else {
                
            }
            
            if EasyGameCenter.isPlayerIdentifiedToGameCenter() {
                    self.PlayerAuthentified.text = "Player Authentified : True"
            } else {
                    self.PlayerAuthentified.text = "Player Authentified : False"
            }
            
        }
        EasyGameCenter.delegate = self
        
    }
    override func didReceiveMemoryWarning() { super.didReceiveMemoryWarning() }
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        /* Set New view controller delegate */
        EasyGameCenter.delegate = self
        println("\n/*****/\nDelegate UIViewController is MainViewController (see viewDidAppear)\n/*****/\n")
    }

    @IBAction func ShowGameCenterAchievements(sender: AnyObject) {
        EasyGameCenter.showGameCenterAchievements {
            () -> Void in
            
            println("Game Center Achievements Is show")
        }
    }
    @IBAction func ShowGameCenterLeaderboards(sender: AnyObject) {

        EasyGameCenter.showGameCenterLeaderboard(leaderboardIdentifier: "International_Classement") {
            () -> Void in
            
            println("Game Center Leaderboards Is show")
        }
    }
    @IBAction func ShowGameCenterChallenges(sender: AnyObject) {
        EasyGameCenter.showGameCenterChallenges {
            () -> Void in
            
            println("Game Center Challenges Is show")
        }
    }
    @IBAction func ShowAuthetificationGameCenter(sender: AnyObject) {
        
        EasyGameCenter.showGameCenterAuthentication { (result) -> Void in
            if result {
                println("Game Center Authentication is open")
            }
        }
    }
    @IBAction func ShowCustomBanner(sender: AnyObject) {
        
       EasyGameCenter.showCustomBanner(title: "Title", description: "My Description...") { () -> Void in
            println("Custom Banner is finish to Show")
        }
    }
}

