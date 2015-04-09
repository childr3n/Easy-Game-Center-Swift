# Easy Game Center  [![](https://img.shields.io/packagist/l/doctrine/orm.svg)]() [![](http://img.shields.io/badge/iOS-8.0%2B-lightgrey.svg)]()


<p align="center">
        <img src="http://s2.postimg.org/jr6rlurax/easy_Game_Center_Swift.png" height="200" width="200" />
</p>
**Easy Game Center** helps to manage Game Center in iOS. Report and track high scores, achievements. Easy Game Center falicite management of Game Center.
**(version 1.02)**

<p align="center">
        <img src="http://g.recordit.co/K1I3O6BEXq.gif" height="500" width="280" />
</p>

# Project Features
Easy Game Center is a great way to use Game Center in your iOS app.

* Swift
* Submit, Save, Retrieve any Game Center leaderboards, achievements in only one line of code.
* Save in cache GKachievements & GKachievementsDescription automatically refreshed
* (New delegate function) When player is connected or not etc...
* Most of the functions CallBack (Handler, completion)
* Useful methods and properties by use Singleton (EasyGameCenter.exampleFunction)
* Just drag and drop the files into your project (EasyGameCenter.swift)
* Frequent updates to the project based on user issues and requests  
* Easily contribute to the project :)
* Example project
* More is coming ... (Challenges etc..)

## Requirements
* Requires a minimum of iOS or 8.0+

## Contributions & Share
Any contribution is more than welcome! You can contribute through pull requests and issues on GitHub. :D

Send me your application's link, if you use Easy Game center, I will add on the cover pagee [@RedWolfStudioFR](https://twitter.com/RedWolfStudioFR) :)

# Documentation
All methods, properties, types, and delegate methods available on the GameCenterManager class are documented below. If you're using [GameKit](https://developer.apple.com/library/ios/documentation/GameKit/Reference/GameKit_Collection/index.html)

## Setup
Setting up Easy Game Center it's really easy. Read the instructions after.

**1.** Add the `GameKit`, `SystemConfiguration` frameworks to your Xcode project
<p align="center">
        <img src="http://s27.postimg.org/45wds3jub/Capture_d_cran_2558_03_20_19_56_34.png" height="100" width="500" />
</p>

**2.** Add the following classes (GameCenter.swift) to your Xcode project (make sure to select Copy Items in the dialog)

**3.** You can initialize Easy Game Center by using the following method call (This is an example, see doc)
```swift
// Add Protocol for delegate fonction "EasyGameCenterDelegate"
class MainViewController: UIViewController,EasyGameCenterDelegate {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Init Easy Game Center
        EasyGameCenter.sharedInstance(self)
    }

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        //Set New view controller delegate, that's when you change UIViewController
        EasyGameCenter.delegate = self
    }
    /**
        Player conected to Game Center, Delegate Func of Easy Game Center
    */
    func easyGameCenterAuthentified() {
        println("\nPlayer Authentified\n")
    }
    /**
        Player not connected to Game Center, Delegate Func of Easy Game Center
    */
    func easyGameCenterNotAuthentified() {
        println("\nPlayer not authentified\n")
    }
    /**
        When GkAchievement & GKAchievementDescription in cache, Delegate Func of Easy Game Center
    */
    func easyGameCenterInCache() {
        println("\nGkAchievement & GKAchievementDescription in cache\n")
    }
}
```

## Initialize
###Protocol Easy Game Center
* **Description :** You should add **EasyGameCenterDelegate** protocol if you want use delegate functions (**easyGameCenterAuthentified,easyGameCenterNotAuthentified,easyGameCenterInCache**)
* **Option :** It is optional (if you do not use the functions, do not add)
```swift
class ExampleViewController: UIViewController,EasyGameCenterDelegate { }
```
###Initialize Easy Game Center
* **Description :** You should setup Easy Game Center when your app is launched. I advise you to **viewDidLoad()** method
```swift
    override func viewDidLoad() {
        super.viewDidLoad()

        // Init Easy Game Center
        EasyGameCenter.sharedInstance(self)
    }
```
###Set new delegate when you change UIViewController
* **Description :** If you have several UIViewController just add this in your UIViewController for set new Delegate
* **Option :** It is optional 
```swift
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)

        //Set New view controller delegate, that's when you change UIViewController
        EasyGameCenter.delegate = self
    }
```
##Delegate function for listen
###Listener Player is authentified
* **Description :** This function is call when player is authentified to Game Center
* **Option :** It is optional 
```swift
    func easyGameCenterAuthentified() {
        println("\nPlayer Authentified\n")
    }
```
###Listener Player is not authentified
* **Description :** This function is call when player is not authentified to Game Center
* **Option :** It is optional 
```swift
    func easyGameCenterNotAuthentified() {
        println("\nPlayer not authentified\n")
    }
```
###Listener when Achievement is in cache
* **Description :** This function is call when GKachievements GKachievementsDescription is in cache
* **Option :** It is optional 
```swift
    func easyGameCenterInCache() {
        println("\nGkAchievement & GKAchievementDescription in cache\n")
    }
```
#Show Methods
##Show Achievements
* **Show Game Center Achievements with completion**
* **Option :** Without completion ```EasyGameCenter.showGameCenterAchievements(completion: nil)```
```swift
        EasyGameCenter.showGameCenterAchievements { 
                (isShow) -> Void in
                if isShow {
                        println("Game Center Achievements is shown")
                }
        }
```
##Show Leaderboard
* **Show Game Center Leaderboard  with completion**
* **Option :** Without completion ```EasyGameCenter.showGameCenterLeaderboard(leaderboardIdentifier: "IdentifierLeaderboard", completion: nil)```
```swift
        EasyGameCenter.showGameCenterLeaderboard(leaderboardIdentifier: "IdentifierLeaderboard") { 
                () -> Void in
                println("Game Center Leaderboards is shown")
        }
```
##Show Challenges
* **Show Game Center Challenges  with completion**
* **Option :** Without completion ```EasyGameCenter.showGameCenterChallenges(completion: nil)```
```swift
        EasyGameCenter.showGameCenterChallenges {
            () -> Void in
            
            println("Game Center Challenges Is shown")
        }
```
##Show authentification page Game Center
* **Show Game Center authentification page with completion**
* **Option :** Without completion ```EasyGameCenter.showGameCenterAuthentication(completion: nil)```
```swift
        EasyGameCenter.showGameCenterAuthentication { 
                (result) -> Void in
                if result {
                        println("Game Center Authentication is open")
                }
        }
```
##Show custom banner
* **Show custom banner Game Center with completion**
* **Option :** Without completion ```EasyGameCenter.showCustomBanner(title: "Title", description: "My Description...", completion: nil)```
```swift
       EasyGameCenter.showCustomBanner(title: "Title", description: "My Description...") { 
                () -> Void in
                println("Custom Banner is finish to Show")
        }
```
##Show custom dialog
* **Show custom dialog Game Center Authentication with completion**
```swift
        EasyGameCenter.openDialogGameCenterAuthentication(
        titre: "Title", 
        message: "Please login you Game Center", 
        buttonOK: "Ok", 
        buttonOpenGameCenterLogin: "Open Game Center") 
        {
            (openGameCenterAuthentification) -> Void in
            if openGameCenterAuthentification {
                println("Player open Game Center authentification")
            } else {
                println("Player cancel Open Game Center authentification")
            }
        }
```
* **Option :** Without completion
```swift
EasyGameCenter.openDialogGameCenterAuthentication(
        titre: Title", 
        message: "Please login you Game Center", 
        buttonOK: "Cancel", 
        buttonOpenGameCenterLogin: "Open Game Center", 
        completion: nil)
```
#Achievements Methods
##Progress Achievements
* **Add progress to an Achievement with show banner**
* **Option :** Without show banner ```EasyGameCenter.reportAchievements(progress: 42.00, achievementIdentifier: "Identifier", showBannnerIfCompleted: false)```
```swift
EasyGameCenter.reportAchievement(progress: 42.00, achievementIdentifier: "Identifier", showBannnerIfCompleted: true)
```
##If Achievement completed 
* **Is completed Achievement**
```swift
let achievementCompleted = EasyGameCenter.isAchievementCompleted(achievementIdentifier: "Identifier")
if achievementOneCompleted {
        println("Yes")
} else {
        println("No")
}
```
##All Achievements completed & Banner not show
* **Get All Achievements completed and banner not show**
```swift
        if let achievements : [String:GKAchievement] = EasyGameCenter.getAchievementCompleteAndBannerNotShowing() {
            for achievement in achievements  {
                var oneAchievement : GKAchievement = achievement.1
                if oneAchievement.completed && oneAchievement.showsCompletionBanner == false {
                
                    println("\n/***** Achievement Description *****/\n")
                    println("\(oneAchievement.identifier)")
                    println("\n/**********/\n")
                    
                }
            }
        }
```
##Show all Achievements completed & Banner not show
* **Show All Achievements completed and banner not show with completion**
* **Option :** Without completion ```EasyGameCenter.showAllBannerAchievementCompleteForBannerNotShowing(nil)```
```swift
        EasyGameCenter.showAllBannerAchievementCompleteForBannerNotShowing { 
        (achievementShow) -> Void in
            if let achievementIsOK = achievementShow {
                println("\(achievementIsOK.identifier)")
            }
        }
```
##Achievements GKAchievementDescription
* **Get all achievements descriptions (GKAchievementDescription) with completion**
```swift
        EasyGameCenter.getGKAllAchievementDescription {
            (arrayGKAD) -> Void in
            
            if let arrayAchievementDescription = arrayGKAD {
                for achievement in arrayAchievementDescription  {
                    println("ID : \(achievement.identifier)")
                    println("Title : \(achievement.title)")
                    println("Achieved Description : \(achievement.achievedDescription)")
                }
            }
        }
```
##Achievements GKAchievement
* **Get One Achievement (GKAchievement)**
```swift
        if let achievement = EasyGameCenter.achievementForIndentifier(identifierAchievement: "achievementIdentifier") {
            /* object GKAchievement */
        }
```
##Tuple Achievements GKAchievement GKAchievementDescription
* **Get Tuple ( GKAchievement , GKAchievementDescription) for identifier Achievement**
```swift
        EasyGameCenter.getTupleGKAchievementAndDescription(achievementIdentifier: "Achievement_One") {            
        (tupleGKAchievementAndDescription) -> Void in
            
            if let tupleInfoAchievement = tupleGKAchievementAndDescription {
                // Extract tuple
                let gkAchievementDescription = tupleInfoAchievement.gkAchievementDescription
                let gkAchievement = tupleInfoAchievement.gkAchievement
                
                // The title of the achievement.
                println("Title : \(gkAchievementDescription.title)")
                // The description for an unachieved achievement.
                println("Achieved Description : \(gkAchievementDescription.achievedDescription)")
            }
        }
```
##Achievement progress
* **Get Progress to an achievement**
```swift
let progressAchievement = EasyGameCenter.getProgressForAchievement(achievementIdentifier: "AchievementIdentifier")
```
##Reset all Achievements
* **Reset all Achievement**
* **Option :** Without completion ```EasyGameCenter.resetAllAchievements(nil)```
```swift
        EasyGameCenter.resetAllAchievements { 
                (achievementReset) -> Void in
                /* achievementReset = GKAchievement */
        }
```
#Leaderboards
##Report
* **Report Score Leaderboard**
```swift
EasyGameCenter.reportScoreLeaderboard(leaderboardIdentifier: "LeaderboardIdentifier", score: 100)
```
##Get GKLeaderboard
* **Get GKLeaderboard with completion**
```swift
        EasyGameCenter.getGKLeaderboard { 
            (resultArrayGKLeaderboard) -> Void in
            if let resultArrayGKLeaderboardIsOK = resultArrayGKLeaderboard as [GKLeaderboard]? {
                for oneGKLeaderboard in resultArrayGKLeaderboardIsOK  {
                
                    println("ID : \(oneGKLeaderboard.identifier)")
                    println("Title :\(oneGKLeaderboard.title)")
                    println("Loading ? : \(oneGKLeaderboard.loading)")
                }
            }
        }
```
##Get GKScore
* **Get GKScore Leaderboard with completion**
```swift
        EasyGameCenter.getGKScoreLeaderboard(leaderboardIdentifier: "International_Classement") {
            (resultGKScore) -> Void in
            if let resultGKScoreIsOK = resultGKScore as GKScore? {

                println("Leaderboard Identifier : \(resultGKScoreIsOK.leaderboardIdentifier)")
                println("Date : \(resultGKScoreIsOK.date)")
                println("Rank :\(resultGKScoreIsOK.rank)")
                println("Hight Score : \(resultGKScoreIsOK.value)")
            }
        }
```
##Get Hight Score (Tuple)
* **Get Hight Score Leaderboard with completion, (Tuple of name,score,rank)**
```swift
        EasyGameCenter.getHighScore(leaderboardIdentifier: "International_Classement") {
            (tupleHighScore) -> Void in
            //(playerName:String, score:Int,rank:Int)
            
            if  tupleHighScore != nil {
                println("Leaderboard Identifier : \(tupleHighScore!.playerName)")
                println("Date : \(tupleHighScore!.score)")
                println("Rank :\(tupleHighScore!.rank)")
            }
        }
```
#Other methods Game Center
##Player identified to Game Center
**Is player identified to gameCenter**
```swift
if EasyGameCenter.isPlayerIdentifiedToGameCenter() { /* Player identified */ } 
```
##Local Player
**Get local Player (GKLocalPlayer)**
```swift
let localPlayer = EasyGameCenter.getLocalPlayer()
```
#Other
**Is Connected to NetWork**
```swift
if EasyGameCenter.isConnectedToNetwork() { /* You have network */ } 
```

### Legacy support
For support of iOS 8+ [@RedWolfStudioFR](https://twitter.com/RedWolfStudioFR) 

Yannick Stephan works hard to have as high feature parity with **Easy Game Center** as possible. 

### License
The MIT License (MIT)

Copyright (c) 2015 Red Wolf Studio, Yannick Stephan

[Red Wolf Studio](http://www.redwolfstudio.fr)

[Yannick Stephan](https://yannickstephan.com)
