# Easy Game Center [![](http://img.shields.io/badge/iOS-7.0%2B-lightgrey.svg)]() [![](http://img.shields.io/badge/iOS-8.0%2B-lightgrey.svg)]()

<p align="center">
        <img src="http://s2.postimg.org/jr6rlurax/easy_Game_Center_Swift.png" height="200" width="200" />
</p>

Easy Game Center helps to manage Game Center in iOS. Report and track high scores, achievements. Easy Game Center falicite management of Game Center.
(version 1.0)

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
###Show Game Center
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
