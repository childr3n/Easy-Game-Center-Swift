# Easy Game Center  [![](https://img.shields.io/packagist/l/doctrine/orm.svg)]() [![](http://img.shields.io/badge/iOS-8.0%2B-lightgrey.svg)]()


<p align="center">
        <img src="http://s2.postimg.org/jr6rlurax/easy_Game_Center_Swift.png" height="200" width="200" />
</p>

Easy Game Center helps to manage Game Center in iOS. Report and track high scores, achievements. Easy Game Center falicite management of Game Center.
(version 1.0)

<p align="center">
        <img src="http://g.recordit.co/fTu2Omk6AA.gif" height="500" width="280" />
        <img src="http://g.recordit.co/gG6zf01NoQ.gif" height="500" width="280" />
</p>

# <!> Project code is not finish, in 1hour  please wait :)
# <!> Project code is not finish, in 1hour  please wait :)
# <!> Project code is not finish, in 1hour  please wait :)

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

## Example in game
http://bit.ly/1zGJMNG

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
* **Get all achievements description (GKAchievementDescription) with completion**
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

/* write ... */






* **Get Achievement (GKAchievement)**
```swift
/**
    Get Achievement (GKAchievement) by string identifier
    
    :param: Identifier Achievement
    
    :returns: GKAchievement OR nil
*/
GameCenter.achievementForIndetifier(identifierAchievement : "IdentifierAchievement")
```

* **Get all achievements completed and banner not show**
```swift
/**
    Get all Achievements Complete during the game and banner wasn't showing
   (is you have instanceGameCenter.showBannerAchievementWhenComplete = false OR addProgressToAnAchievement)
  
    Example :
    if let achievements : [String:GKAchievement] = GameCenter.achievementCompleteAndBannerNotShowing() {
        for achievement in achievements  {
            var oneAchievement : GKAchievement = achievement.1
            if oneAchievement.percentComplete == 100.00 {
                oneAchievement.showsCompletionBanner = true
            }
        }
    }
    
    :returns: [String : GKAchievement] or nil
*/
if let achievements : [String:GKAchievement] = GameCenter.achievementCompleteAndBannerNotShowing() {
        for achievement in achievements  {
                var oneAchievement : GKAchievement = achievement.1
                if oneAchievement.completed {
                        oneAchievement.showsCompletionBanner = true
                }
        }
}
```

* **Shown all achievements completed and banner not show**
```swift
/**
    Show all achievements completed if you have ( showBannerAchievementWhenComplete = false OR addProgressToAnAchievement)
*/
GameCenter.showAllBannerAchievementCompleteForBannerNotShowing()
```

* **Reset one Achievement**
```swift
/**
    Remove One Achievement
    
    :param: Achievement identifier
*/
GameCenter.resetOneAchievement(achievementIdentifier: "AchievementIdentifier")
```

* **Reset All Achievements**
```swift
GameCenter.resetAllAchievements()
```
#Checkup Game Center
* **If player is connected to GameCenter**
```swift
if GameCenter.ifPlayerIdentifiedToGameCenter() {
        print("YES \n")
} else {
        print("NO \n")
}
```

* **Get State of Game Center**
```swift
/**
    Get State of GameCenter
    
    :returns: enum
    - LaunchGameCenter:             Game center is laucher and load
    - PlayerConnectedLoadDataCache: Player connected and data load in cache
    - PlayerConnected:              Player connected and data in cache
    - PlayerNotConnected:           Player not connected to game center
    - Error:                        Error
*/
let gameCenterState = GameCenter.getStateGameCenter()

/* Easy Game Center Load */
if gameCenterState == GameCenter.StateGameCenter.LaunchGameCenter {

/* Player connected and load data in cache */
} else if gameCenterState == GameCenter.StateGameCenter.PlayerConnectedLoadDataCache {

/* Player connected and data in cache */
} else if gameCenterState == GameCenter.StateGameCenter.PlayerConnected {

}
```

###Achievements


###Leaderboards

* **Report to Leaderboard**
```swift
/**
    Reports a score to Game Center
    
    :param: The score Int
    :param: Leaderboard identifier
    :param: completion (bool) when the score is report to game center or Fail
*/
/* With completion */
GameCenter.reportScoreLeaderboard(score: 100.00, leaderboardIdentifier: "classement_internationale") { 
        (result) -> Void in
        if result {
                println("Score is to Game Center !")
        }
}
/* Without completion */
GameCenter.reportScoreLeaderboard(score: Int, leaderboardIdentifier: String, completion: nil)
```

**Get SKScore leaderboard**
```swift
/**
    Get SKScore
    
    :param: Leaderboard Identifier
    :returns: GKScore or nil
*/
if let resultGKScoreOk =  GameCenter.getScoreLeaderboard(leaderboardIdentifier: "classement_internationale") {
       /* Hight score player */    
        print(resultGKScoreOk.value)
        
        /* Rank */
        print(resultGKScoreOk.rank)
        
        /* Date last win (Rank) */
        print(resultGKScoreOk.date)
        
        /* Context */
        print(resultGKScoreOk.context)
        
        /* Player info */
        print(resultGKScoreOk.player)
        
        /* Player ID */
        print(resultGKScoreOk.playerID)

        /* Etc ... */
} 
```

### Legacy support
For support of iOS 7 & 8+ [Yannick Stephan](https://yannickstephan.com) works hard to have as high feature parity with **Simple Game Center** as possible.

### License
CC0 1.0 Universal
<http://creativecommons.org/publicdomain/zero/1.0/>
