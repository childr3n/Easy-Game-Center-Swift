# Easy Game Center  [![](https://img.shields.io/packagist/l/doctrine/orm.svg)]() [![](http://img.shields.io/badge/iOS-8.0%2B-lightgrey.svg)]()


<p align="center">
        <img src="http://s2.postimg.org/jr6rlurax/easy_Game_Center_Swift.png" height="200" width="200" />
</p>

Easy Game Center helps to manage Game Center in iOS. Report and track high scores, achievements. Easy Game Center falicite management of Game Center.
(version 1.0)

<p align="center">
        <img src="http://g.recordit.co/K1I3O6BEXq.gif" height="500" width="280" />
</p>

# Project Features
GameCenter Manager is a great way to use Game Center in your iOS app.

* Submit, Save, Retrieve any Game Center leaderboards, achievements in only one line of code.
* Save in cache achievements & automatically refreshed
* Most of the functions CallBack (Handler, completion)
* Async
* Useful methods and properties by use Singleton (EasyGameCenter.exampleFunction)
* Just drag and drop the files into your project (EasyGameCenter.swift)
* Frequent updates to the project based on user issues and requests  
* Easily contribute to the project
* Example project
* More is coming ... (Challenges etc..)

## Requirements
* Requires a minimum of iOS or 8.0+

## Contributions
Any contribution is more than welcome! You can contribute through pull requests and issues on GitHub. :D

# Documentation
All methods, properties, types, and delegate methods available on the GameCenterManager class are documented below. If you're using [GameKit](https://developer.apple.com/library/ios/documentation/GameKit/Reference/GameKit_Collection/index.html)

## Setup
Setting up Easy Game Center it's really easy. Read the instructions after.

1. Add the `GameKit`, `SystemConfiguration` frameworks to your Xcode project
<p align="center">
        <img src="http://s27.postimg.org/45wds3jub/Capture_d_cran_2558_03_20_19_56_34.png" height="100" width="500" />
</p>

2. Add the following classes (GameCenter.swift) to your Xcode project (make sure to select Copy Items in the dialog)

3. You can initialize Easy Game Center by using the following method call (With Call back when player is authentified)
```swift
    override func viewDidLoad() {
        super.viewDidLoad()

        /* Init Singleton Easy Game Center */
        let eaysGameCenter = EasyGameCenter.sharedInstance {
            (resultPlayerAuthentified) -> Void in
            
            if resultPlayerAuthentified {
                /* When player is authentified to Game Center */
                
            } else {
                /* Player not authentified to Game Center */
                /* No connexion internet or not authentified to Game Center */
            }
        }
        /* Set delegate UIViewController */
        EasyGameCenter.delegate = self
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        /* Set new delegate is you change UIViewController */
        EasyGameCenter.delegate = self
    }
```

## Methods
###Initialize Easy Game Center
You should setup Easy Game Center when your app is launched. I advise you to **viewDidLoad()** method
* **Initialize with completion**
```swift
    override func viewDidLoad() {
        super.viewDidLoad()

        /* Init Easy Game Center Singleton */
        let eaysGameCenter = EasyGameCenter.sharedInstance {
            (resultPlayerAuthentified) -> Void in
            
            if resultPlayerAuthentified {
                /* When player is authentified to Game Center */
                
            
            } else {
                /* Player not authentified to Game Center */
                /* No connexion internet or not authentified to Game Center */
            }
        }
        /* Set delegate UIViewController */
        EasyGameCenter.delegate = self
    }
```
* **Initialize without completion**
```swift
        /* Init Easy Game Center Singleton */
        let gameCenter = GameCenter.sharedInstance
        /* Set Delegate */
        gameCenter.delegate = self
```
* **Initialize change UIViewController Delegate**
```swift
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        /* Set new view controller delegate */
        EasyGameCenter.delegate = self
    }
```
#Show Method
##Show Achievements
* **Show Game Center Achievements with completion**
```swift
        EasyGameCenter.showGameCenterAchievements { 
                () -> Void in
                println("Game Center Achievements is shown")
        }
```
* **Show Game Center Achievements without completion**
```swift
        EasyGameCenter.showGameCenterAchievements(completion: nil)
```
##Show Leaderboard
* **Show Game Center Leaderboard  with completion**
```swift
        EasyGameCenter.showGameCenterLeaderboard(leaderboardIdentifier: "IdentifierLeaderboard") { 
                () -> Void in
                println("Game Center Leaderboards is shown")
        }
```
* **Show Game Center Leaderboard  without completion**
```swift
        EasyGameCenter.showGameCenterLeaderboard(leaderboardIdentifier: "IdentifierLeaderboard", completion: nil)
```
##Show Challenges
* **Show Game Center Challenges  with completion**
```swift
        EasyGameCenter.showGameCenterChallenges {
            () -> Void in
            
            println("Game Center Challenges Is shown")
        }
```
* **Show Game Center Challenges  without completion**
```swift
        EasyGameCenter.showGameCenterChallenges(completion: nil)
```
##Show authentification page Game Center
* **Show Game Center authentification page with completion**
```swift
        EasyGameCenter.showGameCenterAuthentication { 
                (result) -> Void in
                if result {
                        println("Game Center Authentication is open")
                }
        }
```
* **Show Game Center authentification page without completion**
```swift
        EasyGameCenter.showGameCenterAuthentication(completion: nil)
```
##Show custom banner
* **Show custom banner Game Center with completion**
```swift
       EasyGameCenter.showCustomBanner(title: "Title", description: "My Description...") { 
                () -> Void in
                println("Custom Banner is finish to Show")
        }
```
* **Show custom banner Game Center without completion**
```swift
        EasyGameCenter.showCustomBanner(title: "Title", description: "My Description...", completion: nil)
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
* **Show custom dialog Game Center Authentication without completion**
```swift
EasyGameCenter.openDialogGameCenterAuthentication(
        titre: Title", 
        message: "Please login you Game Center", 
        buttonOK: "Cancel", 
        buttonOpenGameCenterLogin: "Open Game Center", 
        completion: nil)
```
#Achievements Method
##Progress Achievements
* **Add progress to an Achievement with completion**
```swift
EasyGameCenter.reportAchievements(progress: 100.00, achievementIdentifier: "Identifier", showBannnerIfCompleted: true) {
        (isSendToGameCenterOrNor) -> Void in
        
        if isSendToGameCenterOrNor {
                /* Achievement is reported to Game Center */   
        } else {
                /* Achievement is Not reported to Game Center (No Internet or player not identified to Game Center)*/  
        }
} 
```
* **Add progress to an Achievement without completion**
```swift
EasyGameCenter.reportAchievements(progress: 100.00, achievementIdentifier: "Identifier", showBannnerIfCompleted: true, completionIsSend: nil)
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
##Achievements completed & banner not show = false
* **Get All Achievements completed and banner not show**
```swift
        if let achievements : [String:GKAchievement] = EasyGameCenter.getAchievementCompleteAndBannerNotShowing() {

            for achievement in achievements  {
                var oneAchievement : GKAchievement = achievement.1
                if oneAchievement.completed && oneAchievement.showsCompletionBanner == false {
                    
                    println("\n/***** Achievement banner not show *****/\n")
                    println("\(oneAchievement.identifier)")
                }
            }
        } else {
            println("\n/***** No Achievement with not showing  *****/\n")
        }
```
* **Show All Achievements completed and banner not show with completion**
```swift
EasyGameCenter.showAllBannerAchievementCompleteForBannerNotShowing { 
        (isShowAchievement) -> Void in
        if isShowAchievement {
              println("One Achievement show, 2, 3, 4 etc...")  
        } else {
                println("No Achievements to show")  
        }
}
```
* **Show All Achievements completed and banner not show without completion**
```swift
EasyGameCenter.showAllBannerAchievementCompleteForBannerNotShowing(completion:nil)
```
##Achievements informations
* **Get all achievements descriptions (GKAchievementDescription) with completion**
```swift
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
```
* **Get One Achievement (GKAchievement)**
```swift
if let achievementDes = EasyGameCenter.achievementForIndetifier(identifierAchievement : "IdentifierAchievement") {
        /* object GKAchievement */
}
```
* **Load GKAchievement in cache**
* (Is call when you init EasyGameCenter, but if is fail example for cut connection, you can recall)
* And when you get Achievement or all Achievement, it shall automatically cached
```swift
EasyGameCenter.loadGKAchievement(completion: { (result) -> Void in
        if result {
                /* GKAchievement it in cache */
        }
})
```
##Reset Achievements
* **Reset one Achievement**
```swift
EasyGameCenter.resetOneAchievement(achievementIdentifier: "Achievement_One") {
        (isResetToGameCenterOrNor) -> Void in
            
        if isResetToGameCenterOrNor {
                /* Is reset to Game Center */
        } else {
                /* Is not reset to Game Center (No internet or player not login */
        }
}
```
#Leaderboards
##Report
* **Report Score Leaderboard with completion**
```swift
EasyGameCenter.reportScoreLeaderboard(leaderboardIdentifier: "International_Classement", score: 100) {
        (isSendToGameCenterOrNor) -> Void in
        if isSendToGameCenterOrNor {
                println("Score send to Game Center")
        } else {
                println("Score NO send to Game Center (No connection or player not identified")
        }
}
```
* **Report Score Leaderboard without completion**
```swift
EasyGameCenter.reportScoreLeaderboard(leaderboardIdentifier: "International_Classement", score: 100,completion:nil)
```
##Get GKLeaderboard
* **Get GKLeaderboard with completion**
```swift
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
```
##Get GKScore
**Get GKScore Leaderboard with completion**
```swift
EasyGameCenter.getGKScoreLeaderboard(leaderboardIdentifier: "International_Classement") {
        (resultGKScore) -> Void in
        if let resultGKScoreIsOK = resultGKScore as GKScore? {
                /* Hight score player */
                print(resultGKScoreIsOK.value)
                
                /* Rank */
                print(resultGKScoreIsOK.rank)
                
                /* Date last win (Rank) */
                print(resultGKScoreIsOK.date)
                
                /* Context */
                print(resultGKScoreIsOK.context)
                
                /* Player info */
                print(resultGKScoreIsOK.player)
                
                /* Player ID */
                print(resultGKScoreIsOK.playerID)
                
                /* Etc ... */
        }
}
```
#Other methods








### Legacy support
For support of iOS 7 & 8+ [Yannick Stephan](https://yannickstephan.com) works hard to have as high feature parity with **Simple Game Center** as possible.

### License
CC0 1.0 Universal
<http://creativecommons.org/publicdomain/zero/1.0/>
