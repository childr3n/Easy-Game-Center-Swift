# Easy Game Center [![](http://img.shields.io/badge/iOS-7.0%2B-lightgrey.svg)]() [![](http://img.shields.io/badge/iOS-8.0%2B-lightgrey.svg)]()

<p align="center">
        <img src="http://imagizer.imageshack.us/v2/320x240q90/538/RMNfHp.png" height="100" width="100" />
</p>

Easy Game Center helps to manage Game Center in iOS. Report and track high scores, achievements.Easy Game Center falicite management of Game Center.
(version 3.5)

# <!> Project code is not finish, in 1 day please wait :)


# Project Features
GameCenter Manager is a great way to use Game Center in your iOS app.

* Sync, Submit, Save, Retrieve, and Track any Game Center leaderboards, achievements in only one line of code.
* Save in cache leaderboards & achievements & automatically refreshed
* CallBack
* Async
* Useful delegate methods and properties by use Singleton GameCenter
* Just drag and drop the files into your project 
* Frequent updates to the project based on user issues and requests  
* Easily contribute to the project

## Requirements
* Requires a minimum of iOS 7.0+ or 8.0+

## Contributions
Any contribution is more than welcome! You can contribute through pull requests and issues on GitHub. :D

# Documentation
All methods, properties, types, and delegate methods available on the GameCenterManager class are documented below. If you're using [GameKit](https://developer.apple.com/library/ios/documentation/GameKit/Reference/GameKit_Collection/index.html)

## Example
Xcode Project : https://github.com/DaRkD0G/Example-GameCenter

## Example in game
http://bit.ly/1zGJMNG

## Setup
Setting up GameCenter Manager is very straightforward. These instructions do not detail how to enable Game Center in your app. You need to setup Game Center before using GameCenter Manager.

1. Add the `GameKit` frameworks to your Xcode project
 [![](http://imagizer.imageshack.us/v2/640x480q90/540/cLGFV6.png)]()

2. Add the following classes (GameCenter.swift) to your Xcode project (make sure to select Copy Items in the dialog)
4. You can initialize Easy Game Center by using the following method call
```swift
class MyClassViewController: UIViewController {

        override func viewDidLoad() {
                super.viewDidLoad()
        
                // Init Easy Game Center Singleton
                let gameCenter = GameCenter.sharedInstance { 
                        (resultConnectToGameCenter) -> Void in
                        if resultConnectToGameCenter {
                                print("Player connected to Game Center")
                        } else {
                                print("No Player connected to Game Center")
                        }
                }
                // Set Delegate
                gameCenter.delegate = self
                
                /** Options **/
                // Not open login page if player is not login to Game Center, the first launch.
                // gameCenter.openLoginPageIfPlayerNotLogin = false
        }
}
```

## Methods
###Initialize Easy Game Center
You should setup Easy Game Center when your app is launched. I advise you to **viewDidLoad()** method

* **Load with completion**
```swift
/* Init Easy Game Center Singleton */
let gameCenter = GameCenter.sharedInstance { 
        (resultConnectToGameCenter) -> Void in
        if resultConnectToGameCenter {
                print("Player connected to Game Center")
        } else {
                print("No Player connected to Game Center")
        }
}
/* Set Delegate */
gameCenter.delegate = self
                
/* Not automatically open login page if player is not login to Game Center, the first launch. */
// gameCenter.openLoginPageIfPlayerNotLogin = false
```
* **Load without completion**
```swift
/* Init Easy Game Center Singleton */
let gameCenter = GameCenter.sharedInstance
/* Set Delegate */
gameCenter.delegate = self
```

###Show Game Center
* **Show Game Center**
```swift
GameCenter.showGameCenter()
```

* **Show Game Center Leaderboard** (Thanks to J0hnniemac author)
```swift
/**
    Show Game Center Leaderboard passed as string into function
    :param: Leaderboard Identifier String
*/
GameCenter.showGameCenterLeaderboard(leaderboardIdentifier: "LeaderboardIdentifier")
```

* **Open Dialog for authentification player**
```swift
/**
    Open Dialog for player see he wasn't authentifate to Game Center and can go to login
    
    :param: Title of dialog
    :param: Message of dialog
*/
GameCenter.openDialogGameCenterAuthentication(#titre:String, message:String)
```

* **Open authentification Game Center page**
```swift
GameCenter.openGameCenterAuthentication()
```

* **Show personalize banner game center**
```swift
/**
    Show banner game center
    
    :param: title       title
    :param: description description
    :param: completion  if show message is showing
*/
/* without completion */
GameCenter.showBannerWithTitle(title: title, description: description, completion: nil)

/* with completion */
GameCenter.showBannerWithTitle(title: String, description: String, completion: { (isShow) -> Void in
        if isShow {
                println("Banner is show")   
        }
})
```
###Checkup Game Center
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
* **Add progress to an Achievement**
```swift
/**
    Add progress to an achievement
    
    :param: Progress achievement Double (ex: 10% = 10.00)
    :param: Achievement Identifier
    :param: if you want show banner or not when is completed
*/
GameCenter.addProgressToAnAchievement(#progress : Double, achievementIdentifier : String, showBannnerIfCompleted : Bool)
```

* **If Achievement is completed**
```swift
/**
    If achievement is completed
    
    :param: achievementIdentifier
    :return: Bool True is completed
*/
if GameCenter.ifAchievementCompleted(achievementIdentifier: "AchievementIdentifier") {
        println("YES")
} else {
        println("NON")
}
```

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
