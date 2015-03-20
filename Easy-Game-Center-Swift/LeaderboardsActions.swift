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
    
    
  
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        let buttonBarOpenGameCenter :UIBarButtonItem =  UIBarButtonItem(title: "Game Center Leaderboards", style: .Bordered, target: self, action: "openGameCenterLeaderboard:")
        self.navigationItem.rightBarButtonItem = buttonBarOpenGameCenter
        
        // Do any additional setup after loading the view, typically from a nib.
        EasyGameCenter.getGKAchievementDescription { (arrayGKAD) -> Void in
            if arrayGKAD != nil {
           //     self.AchievementsNumber.text = "Number Achievements :  \(arrayGKAD!.count)"
            }
            
        }
        
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        /* Set New view controller delegate */
        EasyGameCenter.delegate = self
        println("\n/*****/\nDelegate UIViewController is LeaderboardsActions (see viewDidAppear)\n/*****/\n")
    }
    //(IBAction)refreshClicked:(id)sender
    
    @IBAction func openGameCenterLeaderboard(sender: AnyObject) {
        
        EasyGameCenter.showGameCenterLeaderboard(leaderboardIdentifier: "International_Classement", completion: {
            () -> Void in
            println("You open Game Center Achievements")
        })
    }

    @IBAction func ActionReportScoreLeaderboard(sender: AnyObject) {

        EasyGameCenter.reportScoreLeaderboard(leaderboardIdentifier: "International_Classement", score: 100) {
            (isSendToGameCenterOrNor) -> Void in
            if isSendToGameCenterOrNor {
                println("Score send to Game Center")
            } else {
                println("Score NO send to Game Center (No connection or player not identified")
            }
        }
        

    }
    
    @IBAction func ActionGetLeaderboards(sender: AnyObject) {
        EasyGameCenter.getLeaderboards { (resultArrayGKLeaderboard) -> Void in
            if let resultArrayGKLeaderboardIsOK = resultArrayGKLeaderboard as [GKLeaderboard]? {
                for oneGKLeaderboard in resultArrayGKLeaderboardIsOK  {
                    
                    println("\n/***** Achievement Description *****/\n")
                    println("ID : \(oneGKLeaderboard.identifier)")
                    println("Title :\(oneGKLeaderboard.title)")
                    println("Hight Score : \(oneGKLeaderboard.scores)")
                    println("\n/**********/\n")
                    
                }
            }

        }
    }
    

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}

