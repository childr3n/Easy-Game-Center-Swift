//
//  ViewController.swift
//  Easy-Game-Center-Swift
//
//  Created by DaRk-_-D0G on 19/03/2558 E.B..
//  Copyright (c) 2558 ère b. DaRk-_-D0G. All rights reserved.
//

import UIKit


/*####################################################################################################*/
/*                              Add >>> EasyGameCenterDelegate <<< for delegate                       */
/*####################################################################################################*/
class MainViewController: UIViewController,EasyGameCenterDelegate {
    
    @IBOutlet weak var Name: UILabel!
    @IBOutlet weak var PlayerID: UILabel!
    @IBOutlet weak var PlayerAuthentified: UILabel!
    
    /*####################################################################################################*/
    /*                       in ViewDidLoad, Set Delegate UIViewController                                */
    /*####################################################################################################*/
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Easy Game Center"
        
        /**
        Set Delegate UIViewController
        */
        EasyGameCenter.sharedInstance(self)
        
        
    }
    
    /*####################################################################################################*/
    /*    Set New view controller delegate, is when you change you change UIViewControlle                 */
    /*####################################################################################################*/
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        /**
        Set New view controller delegate, when you change UIViewController
        */
        EasyGameCenter.delegate = self
        println("\n/*****/\nDelegate UIViewController is MainViewController (see viewDidAppear)\n/*****/\n")
    }
    /*####################################################################################################*/
    /*                               Delegate Func Easy Game Center                                       */
    /*####################################################################################################*/
    /**
    Player conected to Game Center, Delegate Func of Easy Game Center
    */
    func easyGameCenterAuthentified() {
        
        println("\nPlayer Authentified\n")
        
        let localPlayer = EasyGameCenter.getLocalPlayer()
        self.PlayerID.text = "Player ID : \(localPlayer.playerID)"
        self.Name.text = "Name : \(localPlayer.alias)"
        self.PlayerAuthentified.text = "Player Authentified : True"
        
    }
    /**
    Player not connected to Game Center, Delegate Func of Easy Game Center
    */
    func easyGameCenterNotAuthentified() {
        println("\nPlayer not authentified\n")
        self.PlayerAuthentified.text = "Player Authentified : False"
    }
    /**
    When GkAchievement & GKAchievementDescription in cache, Delegate Func of Easy Game Center
    */
    func easyGameCenterInCache() {
        println("\nGkAchievement & GKAchievementDescription in cache\n")
        
    }
    /*####################################################################################################*/
    /*                                          Button                                                    */
    /*####################################################################################################*/
    @IBAction func ShowGameCenterAchievements(sender: AnyObject) {
        EasyGameCenter.showGameCenterAchievements { (isShow) -> Void in
            if isShow {
                println("Game Center Achievements Is show")
            }
        }
        
    }
    @IBAction func ShowGameCenterLeaderboards(sender: AnyObject) {
        
        EasyGameCenter.showGameCenterLeaderboard(leaderboardIdentifier: "International_Classement") { (isShow) -> Void in
            println("Game Center Leaderboards Is show")
        }
    }
    @IBAction func ShowGameCenterChallenges(sender: AnyObject) {
        EasyGameCenter.showGameCenterChallenges {
            () -> Void in
            
            println("Game Center Challenges Is show")
        }
    }
    
    
    /* pdpfkdp */
    
    @IBAction func ShowAuthetificationGameCenter(sender: AnyObject) {
        
        EasyGameCenter.showGameCenterAuthentication {
            (result) -> Void in
            if result {
                println("Is open Game Center Authentication :)")
            }
        }
    }
    @IBAction func ShowCustomBanner(sender: AnyObject) {
        
        EasyGameCenter.showCustomBanner(title: "Title", description: "My Description...") { () -> Void in
            println("Custom Banner is finish to Show")
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    
}

