//
//  ViewController.swift
//  Easy-Game-Center-Swift
//
//  Created by DaRk-_-D0G on 19/03/2558 E.B..
//  Copyright (c) 2558 ère b. DaRk-_-D0G. All rights reserved.
//

import UIKit
import GameKit

class AchievementsActions: UIViewController {
    
    /*####################################################################################################*/
    /*                                          viewDidLoad                                               */
    /*####################################################################################################*/
    @IBOutlet weak var AchievementsNumber: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let buttonBarOpenGameCenter :UIBarButtonItem =  UIBarButtonItem(title: "Game Center Achievement", style: .Bordered, target: self, action: "openGameCenterAchievement:")
        self.navigationItem.rightBarButtonItem = buttonBarOpenGameCenter
        
        
        EasyGameCenter.getGKAllAchievementDescription {
            (arrayGKAD) -> Void in
            
            if let arrayAchievementDescription = arrayGKAD {
                self.AchievementsNumber.text = "Number Achievements :  \(arrayAchievementDescription.count)"
            }
            
        }
        
    }
    
    /*####################################################################################################*/
    /*    Set New view controller delegate, is when you change you change UIViewControlle                 */
    /*####################################################################################################*/
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        /* Set New view controller delegate */
        EasyGameCenter.delegate = self
    }
    /*####################################################################################################*/
    /*                                          Button                                                    */
    /*####################################################################################################*/
    
    @IBAction func openGameCenterAchievement(sender: AnyObject) {
        
        EasyGameCenter.showGameCenterAchievements { (isShow) -> Void in
            println("You open Game Center Achievements")
        }
    }
    @IBAction func ActionGetAchievementsDescription(sender: AnyObject) {
        
        
        EasyGameCenter.getTupleGKAchievementAndDescription(achievementIdentifier: "Achievement_One") { (tupleGKAchievementAndDescription) -> Void in
            
            if let tupleInfoAchievement = tupleGKAchievementAndDescription {
                
                let gkAchievementDescription = tupleInfoAchievement.gkAchievementDescription
                let gkAchievement = tupleInfoAchievement.gkAchievement
                println("\n/***** Achievement Description *****/\n")
                // The title of the achievement.
                println("Title : \(gkAchievementDescription.title)")
                // Whether or not the achievement should be listed or displayed if not yet unhidden by the game.
                println("Hidden? : \(gkAchievement.identifier)")
                // The description for an unachieved achievement.
                println("Achieved Description : \(gkAchievementDescription.achievedDescription)")
                // The description for an achieved achievement.
                println("Unachieved Description : \(gkAchievementDescription.unachievedDescription)")
                println("\n/**********/\n")
            }
        }
    }
    
    @IBAction func ReportAchievementOne(sender: AnyObject) {
        
        if EasyGameCenter.isAchievementCompleted(achievementIdentifier: "Achievement_One") {
            AppDelegate.simpleMessage(title: "isAchievementCompleted", message: "Achievement is already report", uiViewController: self)
        } else {
            EasyGameCenter.reportAchievement(progress: 100.00, achievementIdentifier: "Achievement_One")
        }
        
        
    }
    
    
    @IBAction func IfAchievementIsFinished(sender: AnyObject) {
        
        
        let achievementOneCompleted = EasyGameCenter.isAchievementCompleted(achievementIdentifier: "Achievement_One")
        
        if achievementOneCompleted {
            AppDelegate.simpleMessage(title: "isAchievementCompleted", message: "Yes", uiViewController: self)
        } else {
            if EasyGameCenter.isPlayerIdentifiedToGameCenter() {
                AppDelegate.simpleMessage(title: "isAchievementCompleted", message: "No", uiViewController: self)
            } else {
                AppDelegate.simpleMessage(title: "isAchievementCompleted", message: "Player not identified", uiViewController: self)
            }
            
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /*
     <!> Remove Apple want reset all achievements.
    @IBAction func ResetAchievementOne(sender: AnyObject) {
        
        EasyGameCenter.resetOneAchievement(achievementIdentifier: "Achievement_One") {
            (isResetToGameCenterOrNor) -> Void in
            
            if isResetToGameCenterOrNor {
                AppDelegate.simpleMessage(title: "ResetAchievementOne", message: "Yes", uiViewController: self)
            } else {
                AppDelegate.simpleMessage(title: "ResetAchievementOne", message: "No", uiViewController: self)
            }
        }
    }*/
    
    
    @IBAction func ReportAchievementTwo(sender: AnyObject) {
        
        
        if EasyGameCenter.isAchievementCompleted(achievementIdentifier: "Achievement_Two") {
            AppDelegate.simpleMessage(title: "isAchievementCompleted", message: "Achievement is already report", uiViewController: self)
        } else {
            EasyGameCenter.reportAchievement(progress: 100.00, achievementIdentifier: "Achievement_Two", showBannnerIfCompleted: false)
            
            AppDelegate.simpleMessage(title: "report Achievements", message: "Yes i'am ! but i'm not show", uiViewController: self)
        }
        
        
    }
    
    
    @IBAction func AchievementCompletedAndNotShowing(sender: AnyObject) {
        
        if let achievements : [GKAchievement] = EasyGameCenter.getAchievementCompleteAndBannerNotShowing() {
            
            for oneAchievement in achievements  {
                if oneAchievement.completed && oneAchievement.showsCompletionBanner == false {
                    
                    println("\n/***** Achievement Description *****/\n")
                    println("\(oneAchievement.identifier)")
                    println("\n/**********/\n")
                    
                }
            }
        } else {
            println("\n/***** NO Achievement with not showing  *****/\n")
        }
        
        
    }
    
    @IBAction func ShowAchievementCompletedAndNotShowing(sender: AnyObject) {
        EasyGameCenter.showAllBannerAchievementCompleteForBannerNotShowing(nil)
        
    }
    @IBAction func GetAllChievementsDescription(sender: AnyObject) {
        EasyGameCenter.getGKAllAchievementDescription {
            (arrayGKAD) -> Void in
            
            if let arrayAchievementDescription = arrayGKAD {
                for achievement in arrayAchievementDescription {
                    println("\n/***** Achievement Description *****/\n")
                    println("ID : \(achievement.identifier)")
                    // The title of the achievement.
                    println("Title : \(achievement.title)")
                    // Whether or not the achievement should be listed or displayed if not yet unhidden by the game.
                    println("Hidden? : \(achievement.hidden)")
                    // The description for an unachieved achievement.
                    println("Achieved Description : \(achievement.achievedDescription)")
                    // The description for an achieved achievement.
                    println("Unachieved Description : \(achievement.unachievedDescription)")
                    println("\n/**********/\n")
                }
            }
        }
    }
    
    @IBAction func ResetAllAchievements(sender: AnyObject) {
        EasyGameCenter.resetAllAchievements()
            
    }
}

