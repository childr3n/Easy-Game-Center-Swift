//
//  ViewController.swift
//  Easy-Game-Center-Swift
//
//  Created by DaRk-_-D0G on 19/03/2558 E.B..
//  Copyright (c) 2558 ère b. DaRk-_-D0G. All rights reserved.
//

import UIKit
import GameKit

class LeaderboardsActions: UIViewController {
    
    


    /*####################################################################################################*/
    /*                                          viewDidLoad                                               */
    /*####################################################################################################*/
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        let buttonBarOpenGameCenter :UIBarButtonItem =  UIBarButtonItem(title: "Game Center Leaderboards", style: .Bordered, target: self, action: "openGameCenterLeaderboard:")
        self.navigationItem.rightBarButtonItem = buttonBarOpenGameCenter

        
    }
    
    /*####################################################################################################*/
    /*    Set New view controller delegate, is when you change you change UIViewControlle                 */
    /*####################################################################################################*/
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        /* Set New view controller delegate */
        EasyGameCenter.delegate = self
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /*####################################################################################################*/
    /*                                          Button                                                    */
    /*####################################################################################################*/
    @IBAction func openGameCenterLeaderboard(sender: AnyObject) {
        
        EasyGameCenter.showGameCenterLeaderboard(leaderboardIdentifier: "International_Classement", completion: {
            (result) -> Void in
            if result {
                println("You open Game Center Achievements")  
            }
            
        })
    }
    
    @IBAction func ActionReportScoreLeaderboard(sender: AnyObject) {
        
        EasyGameCenter.reportScoreLeaderboard(leaderboardIdentifier: "International_Classement", score: 100)
        println("Score send to Game Center")
        
    }
    
    @IBAction func ActionGetLeaderboards(sender: AnyObject) {
        EasyGameCenter.getGKLeaderboard {
            (resultArrayGKLeaderboard) -> Void in
            if let resultArrayGKLeaderboardIsOK = resultArrayGKLeaderboard as [GKLeaderboard]? {
                for oneGKLeaderboard in resultArrayGKLeaderboardIsOK  {
                    
                    println("\n/***** Get Leaderboards (getGKLeaderboard) *****/\n")
                    println("ID : \(oneGKLeaderboard.identifier)")
                    println("Title :\(oneGKLeaderboard.title)")
                    println("Loading ? : \(oneGKLeaderboard.loading)")
                    println("\n/**********/\n")
                    
                }
            }
        }
    }
    
    @IBAction func ActionGetGKScoreLeaderboard(sender: AnyObject) {
        EasyGameCenter.getGKScoreLeaderboard(leaderboardIdentifier: "International_Classement") {
            (resultGKScore) -> Void in
            if let resultGKScoreIsOK = resultGKScore as GKScore? {
                
                println("\n/***** Get GKScore Leaderboard (getGKScoreLeaderboard) *****/\n")
                
                println("Leaderboard Identifier : \(resultGKScoreIsOK.leaderboardIdentifier)")
                println("Date : \(resultGKScoreIsOK.date)")
                println("Rank :\(resultGKScoreIsOK.rank)")
                println("Hight Score : \(resultGKScoreIsOK.value)")
                println("\n/**********/\n")
            }
        }
    }
    
  
    @IBAction func GetHighScore(sender: AnyObject) {
        EasyGameCenter.getHighScore(leaderboardIdentifier: "International_Classement") {
            (tupleHighScore) -> Void in
            /// tupleHighScore = (playerName:String, score:Int,rank:Int)?
            
            if  tupleHighScore != nil {
                println("\n/***** Hight Score (getHighScore) *****/\n")
                println("Player Name : \(tupleHighScore!.playerName)")
                println("Score : \(tupleHighScore!.score)")
                println("Rank :\(tupleHighScore!.rank)")
                println("\n/**********/\n")
            }
            
        }
    }

    
    
}

