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

    @IBOutlet weak var AchievementsNumber: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let buttonBarOpenGameCenter :UIBarButtonItem =  UIBarButtonItem(title: "Game Center Achievement", style: .Bordered, target: self, action: "openGameCenterAchievement:")
        self.navigationItem.rightBarButtonItem = buttonBarOpenGameCenter
        
        // Do any additional setup after loading the view, typically from a nib.
        EasyGameCenter.getGKAllAchievementDescription { (arrayGKAD) -> Void in
            if arrayGKAD != nil {
                self.AchievementsNumber.text = "Number Achievements :  \(arrayGKAD!.count)"
            }
        }
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        /* Set New view controller delegate */
        EasyGameCenter.delegate = self
        println("\n/*****/\nDelegate UIViewController is AchievementsActions (see viewDidAppear)\n/*****/\n")
    }
    
    override func didReceiveMemoryWarning() { super.didReceiveMemoryWarning() }

    
    @IBAction func openGameCenterAchievement(sender: AnyObject) {
    
        EasyGameCenter.showGameCenterAchievements { (isShow) -> Void in
            println("You open Game Center Achievements")
        }
    }
    @IBAction func ActionGetAchievementsDescription(sender: AnyObject) {
        EasyGameCenter.getGKAllAchievementDescription {
            (arrayGKAD) -> Void in
            if arrayGKAD != nil {
                for achievement in arrayGKAD!  {

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
            } else {
                println("\n Not Connected Internet OR Game Center ... \n")
            }
        }
    }
    
    @IBAction func ReportAchievementOne(sender: AnyObject) {
        EasyGameCenter.reportAchievements(progress: 100.00, achievementIdentifier: "Achievement_One", showBannnerIfCompleted: true)
        AppDelegate.simpleMessage(title: "report Achievements", message: "Yes i'am ! i haven't internet i save Achievemet and report when connection whith Game Center Apple is OK", uiViewController: self)
        

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
    
    
    
    @IBAction func ResetAchievementOne(sender: AnyObject) {
        
        EasyGameCenter.resetOneAchievement(achievementIdentifier: "Achievement_One") {
            (isResetToGameCenterOrNor) -> Void in
            
            if isResetToGameCenterOrNor {
                AppDelegate.simpleMessage(title: "ResetAchievementOne", message: "Yes", uiViewController: self)
            } else {
                AppDelegate.simpleMessage(title: "ResetAchievementOne", message: "No", uiViewController: self)
            }
        }
    }
   
   
    @IBAction func ReportAchievementTwo(sender: AnyObject) {
        EasyGameCenter.reportAchievements(progress: 100.00, achievementIdentifier: "Achievement_Two", showBannnerIfCompleted: false)
        
        AppDelegate.simpleMessage(title: "report Achievements", message: "Yes i'am ! but i'm not show", uiViewController: self)

    }
    

    @IBAction func AchievementCompletedAndNotShowing(sender: AnyObject) {

        if let achievements : [String:GKAchievement] = EasyGameCenter.getAchievementCompleteAndBannerNotShowing() {

            for achievement in achievements  {
                var oneAchievement : GKAchievement = achievement.1
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
            if let arrayGKADIsOK = arrayGKAD {
                for achievement in arrayGKADIsOK  {
                    println("\n/***** Achievement Description *****/\n")
                    println(achievement)
                    println("\n/**********/\n")
                }
            }
        }
    }
    
    @IBAction func ResetAllAchievements(sender: AnyObject) { EasyGameCenter.resetAllAchievements(nil) }
}

