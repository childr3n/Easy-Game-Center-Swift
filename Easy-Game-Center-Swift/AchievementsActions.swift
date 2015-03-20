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
        // Do any additional setup after loading the view, typically from a nib.
        EasyGameCenter.getGKAchievementDescription { (arrayGKAD) -> Void in
            if arrayGKAD != nil {
                self.AchievementsNumber.text = "Number Achievements :  \(arrayGKAD!.count)"
            }

        }
        
    }
    
    @IBAction func ActionGetAchievementsDescription(sender: AnyObject) {
        EasyGameCenter.getGKAchievementDescription { (arrayGKAD) -> Void in
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
            }
        }
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}

