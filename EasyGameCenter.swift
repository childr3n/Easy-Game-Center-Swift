//
//  GameCenter.swift
//
//  Created by Yannick Stephan DaRk-_-D0G on 19/12/2014.
//  YannickStephan.com
//
//	iOS 7.0, 8.0+
//
//	The MIT License (MIT)
//	Copyright (c) 2014 Tobias Due Munk
//
//	Permission is hereby granted, free of charge, to any person obtaining a copy of
//	this software and associated documentation files (the "Software"), to deal in
//	the Software without restriction, including without limitation the rights to
//	use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of
//	the Software, and to permit persons to whom the Software is furnished to do so,
//	subject to the following conditions:
//
//	The above copyright notice and this permission notice shall be included in all
//	copies or substantial portions of the Software.
//
//	THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//	IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS
//	FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR
//	COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER
//	IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
//	CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

import Foundation
import GameKit
import SystemConfiguration


/**
GameCenter iOS
*/
class EasyGameCenter: NSObject, GKGameCenterControllerDelegate {
    
    /**
    Enum of state of game center
    
    - LaunchGameCenter:             Game center is laucher and load
    - PlayerConnected:              Player connected and data in cache
    - PlayerConnectedLoadDataCache: Player connected and data load in cache
    - PlayerNotConnected:           Player not connected to game center
    - Error:                        Error
    */
    enum StateGameCenter {
        
        case Loading
        case PlayerConnected
        case PlayerNotConnected
        case Error
        
        
    }

    /// State of Game Center
    var stateOfGameCenter : StateGameCenter = .Loading
    
    /**
    Load Game Center and load data in cache
    
    :param: completion if load Game Center is OK
    */
    /* func loadDataGameCenter(#completion: ((result:Bool) -> Void)?) {
    self.loadGKAchievement(completion: {
    (result) -> Void in
    
    print("loadGKAchievement\n\(result)\n")
    
    if (!result) {
    completion!(result: false)
    } else {
    
    
    }
    
    })
    }*/
    /// The local player object.
    var localPlayer = GKLocalPlayer.localPlayer()
    
    /// Achievements GKAchievement Cache
    private var achievementsCache = [String:GKAchievement]()
    
    /// Achievements GKAchievementDescription Cache
    //private var achievementsInformationCache = [String:GKAchievementDescription]()
    
    /// Achievements GKAchievementDescription Cache
    //private var leaderBoardsCache = [String:GKLeaderboard]()
    
    //localPlayerScore
    private var scoresleaderBoard = [String:GKScore]()
    
    /// ViewController MainView
    var delegate: UIViewController?

    
    
    /*_______________________________________ STARTER _______________________________________*/
    /**
    *  Static Value
    */
    struct Static {
        static var onceToken: dispatch_once_t = 0
        static var instance: EasyGameCenter? = nil
    }
    /**
    Start Singleton GameCenter Instance
    
    :param: completion Return when Game Center login player and Cache is loaded
    
    :returns: GameCenter instance
    */
    class func sharedInstance(#completion: ((resultConnectToGameCenter:Bool) -> Void)?) -> EasyGameCenter {
        
        if Static.instance == nil {
            dispatch_once(&Static.onceToken) {
                Static.instance = EasyGameCenter()
                EasyGameCenter.loginPlayerToGameCenter({
                    (result) in
                    if completion != nil {
                        completion!(resultConnectToGameCenter: result)
                    }
                })
            }
            
        }
        return Static.instance!
    }
    private var timer: NSTimer?
    /**
    Start Singleton GameCenter Instance
    */
    class var sharedInstance: EasyGameCenter {
        
        if Static.instance == nil {
            dispatch_once(&Static.onceToken) {
                Static.instance = EasyGameCenter()
                EasyGameCenter.loginPlayerToGameCenter(nil)
            }
            
        }
        
        return Static.instance!
    }
    
    /**
    Constructor
    */
    override init() { super.init() }
    /*____________________________ GameCenter Private Function __________________________________________________*/
    /**
    Login player to GameCenter With Handler Authentification
    
    :param: completion (Bool) if player login to Game Center (true or false)
    */
    class func loginPlayerToGameCenter(#completion: ((result:Bool) -> Void)?)  {
        let gameCenter = EasyGameCenter.sharedInstance
        
        if EasyGameCenter.isConnectedToNetwork() {
            gameCenter.localPlayer.authenticateHandler = {(var gameCenterVC:UIViewController!, var error:NSError!) ->
                Void in
                
                /* If got error / Or player not set value for login */
                if error != nil {
                    
                    gameCenter.stateOfGameCenter = .Error
                    if completion != nil {
                        completion!(result: false)
                    }
                    
                } else {
                    
                    /* Login to game center need Open page */
                    if gameCenterVC != nil {
                        if let delegateController = gameCenter.delegate {
                            delegateController.presentViewController(gameCenterVC, animated: true, completion: nil)
                        }
                        
                        
                    /* Login is ok */
                    } else if gameCenter.localPlayer.authenticated == true {
                        
                        gameCenter.stateOfGameCenter = .Loading
                        gameCenter.loadGKAchievement(completion: { (result) -> Void in
                            
                            gameCenter.stateOfGameCenter = .PlayerConnected
                            
                            if completion != nil { completion!(result: true) }
                        })
                        
                    } else  {
                        gameCenter.stateOfGameCenter = .PlayerNotConnected
                        if completion != nil { completion!(result: false) }
                    }
                }
            }
        }
    }
    
    
    /**
    Load achievement in cache
    */
    private func loadGKAchievement(#completion: ((result:Bool) -> Void)?){
        if EasyGameCenter.isConnectedToNetwork() && EasyGameCenter.getStateGameCenter() == .PlayerConnected {
            GKAchievement.loadAchievementsWithCompletionHandler({ (var achievements:[AnyObject]!, error:NSError!) -> Void in
                if error != nil {
                    println("Game Center: could not load achievements, error: \(error)")
                }
                if achievements != nil {
                    for achievement in achievements  {
                        if let oneAchievement = achievement as? GKAchievement {
                            self.achievementsCache[oneAchievement.identifier] = oneAchievement
                        }
                    }
                    completion!(result: true)
                } else {
                    completion!(result: false)
                }
            })
        }

    }
    
    /*for achievement in achievementsDescription  {
    /* if let oneAchievementDes = achievement as? GKAchievementDescription {
    self.achievementsInformationCache[oneAchievementDes.identifier] = oneAchievementDes
    }*/
    }*/
    
    
    /**
    Load GKachievement in cache
    
    :param: completion load is ok
    */
    private func getGKAchievementDescription(#completion: ((result:[GKAchievementDescription]?) -> Void)){
        if EasyGameCenter.isConnectedToNetwork() && EasyGameCenter.getStateGameCenter() == .PlayerConnected {
            GKAchievementDescription.loadAchievementDescriptionsWithCompletionHandler {
                (var achievementsDescription:[AnyObject]!, error:NSError!) -> Void in
                
                if error != nil {
                    println("Game Center: couldn't load achievementInformation, error: \(error)")
                }
                if let achievementsIsArrayGKAchievementDescription = achievementsDescription as? [GKAchievementDescription] {
                    completion(result: achievementsIsArrayGKAchievementDescription)
                    
                } else {
                    completion(result: nil)
                }
            }
        }

    }
    /*
if leaderboards != nil {
for oneLeaderboard in leaderboards  {
if let oneLeaderboardOK = oneLeaderboard as? GKLeaderboard {
self.leaderBoardsCache[oneLeaderboardOK.identifier] = oneLeaderboardOK
}
}*/
    /**
    Load Leaderboards in cache

    :param: completion if completion is ok
    */
    private func getLeaderboards(#completion: ((result:[GKLeaderboard]?) -> Void)) {
        if EasyGameCenter.isConnectedToNetwork() && EasyGameCenter.getStateGameCenter() == .PlayerConnected {
            GKLeaderboard.loadLeaderboardsWithCompletionHandler {
                (var leaderboards:[AnyObject]!, error:NSError!) -> Void in
                
                if error != nil {
                    println("Game Center: couldn't loadLeaderboards, error: \(error)")
                }
                
                if let leaderboardsIsArrayGKLeaderboard = leaderboards as? [GKLeaderboard] {
                    completion(result: leaderboardsIsArrayGKLeaderboard)
                    
                } else {
                    completion(result: nil)
                }
            }
        }

    }
    /**
    Load GKScore of leaderboards in cache
    
    :param: completion if load in cache is OK
    */
    private func  getGKScoreOfLeaderboard(#leaderboardIdentifier:String, completion: ((result:GKScore?) -> Void)) {
            /*oneLeaderBoard.loadScoresWithCompletionHandler { (scores, error) ->
                Void in
                if error != nil {
                    println("Error: \(error!.localizedDescription)")
                    completion!(result: false)
                } else if (scores != nil) {
                    print(oneLeaderBoard.identifier)
                    print(oneLeaderBoard.localPlayerScore)
                    self.scoresleaderBoard[oneLeaderBoard.identifier] = oneLeaderBoard.localPlayerScore
                    if completion != nil { completion!(result: true) }
                }
            }*/
        
        if EasyGameCenter.isConnectedToNetwork() && EasyGameCenter.getStateGameCenter() == .PlayerConnected {
            let leaderBoardRequest = GKLeaderboard()
            leaderBoardRequest.identifier = leaderboardIdentifier
            leaderBoardRequest.loadScoresWithCompletionHandler { (resultGKScore, error) ->
                Void in
                if error != nil || resultGKScore == nil {
                    completion(result: nil)
                    
                } else  {
                    completion(result: leaderBoardRequest.localPlayerScore)
                }
            }
        }
        
        
    }
    
    
    
    /*_______________________________ Internal Delagate Func _______________________________________________*/
    /**
    Dismiss Game Center when player open
    :param: GKGameCenterViewController
    
    Override of GKGameCenterControllerDelegate
    */
    internal func gameCenterViewControllerDidFinish(gameCenterViewController: GKGameCenterViewController!) {
        gameCenterViewController.dismissViewControllerAnimated(true, completion: nil)
    }
    /*____________________________ GameCenter Public __________________________________________________*/
    /**
    Show Game Center Player
    
    */
    class func showGameCenter(#completion: ((result:Bool) -> Void)) {
        if EasyGameCenter.getStateGameCenter() == .PlayerConnected || EasyGameCenter.getStateGameCenter() == .Loading {
        let gameCenter = EasyGameCenter.Static.instance!
        if let delegateController = gameCenter.delegate {
            
                var gc = GKGameCenterViewController()
                gc.gameCenterDelegate = gameCenter
                delegateController.presentViewController(gc, animated: true, completion: {
                    () -> Void in
                    
                    completion(result:true)
                })

            } else {
                completion(result:false)
            }
        } else {
            completion(result:false)
        }
    }
    /**
    Open Dialog for player see he wasn't authentifate to Game Center and can go to login
    
    :param: titre   Title of dialog
    :param: message Message of dialog
    */
    class func openDialogGameCenterAuthentication(#titre:String, message:String, completion: ((result:Bool) -> Void)?) {
        
        let gameCenter = EasyGameCenter.Static.instance!
        var alert = UIAlertController(title: titre, message: message, preferredStyle: UIAlertControllerStyle.ActionSheet)
        
        if let delegateOK = gameCenter.delegate {
            alert.popoverPresentationController?.sourceView = delegateOK.view as UIView
            
            delegateOK.presentViewController(alert, animated: true, completion: nil)
            
            alert.addAction(UIAlertAction(title: "Ok", style: .Default, handler: {
                action in
                
                if completion != nil {
                    completion!(result: false)
                }
                
            }))
            
            alert.addAction(UIAlertAction(title: "Open Game Center", style: .Default, handler: {
                action in
                
                EasyGameCenter.openGameCenterAuthentication(completion: { (resultOpenGameCenter) -> Void in
                    if completion != nil {
                        completion!(result: resultOpenGameCenter)
                    }
                })
                
            }))
        }

    }
    /**
    Open authetification Game Center
    */
    class func openGameCenterAuthentication(#completion: ((result:Bool) -> Void)?) {
        if completion != nil {
            completion!(result: UIApplication.sharedApplication().openURL(NSURL(string: "gamecenter:")!))
        }
        
    }
    /* class func authenticateLocalPlayer(){
    let gameCenter = GameCenter.sharedInstance
    if let delegateController = gameCenter.delegate {
    var localPlayer = GKLocalPlayer()
    localPlayer.authenticateHandler = {(viewController, error) -> Void in
    if ((viewController) != nil) {
    delegateController.presentViewController(viewController, animated: true, completion: nil)
    }else{
    println("(GameCenter) Player authenticated: \(GKLocalPlayer.localPlayer().authenticated)")
    }
    
    }
    }
    
    
    }*/
    
    /**
    Show Game Center Leaderboard passed as string into func
    
    :param: leaderboard Identifier
    */
    class func showGameCenterLeaderboard(#leaderboardIdentifier :String) {
        
        if EasyGameCenter.getStateGameCenter() == .PlayerConnected || EasyGameCenter.getStateGameCenter() == .Loading && leaderboardIdentifier != "" {
        let gameCenter = EasyGameCenter.Static.instance!
        if let delegateController = gameCenter.delegate {
            
                var gc = GKGameCenterViewController()
                gc.gameCenterDelegate = gameCenter
                gc.leaderboardIdentifier = leaderboardIdentifier
                gc.viewState = GKGameCenterViewControllerState.Leaderboards
                delegateController.presentViewController(gc, animated: true, completion: nil)
            }
        }
    }
    /**
    Get State of GameCenter
    
    :returns: enum
    - LaunchGameCenter:             Game center is laucher and load
    - PlayerConnected:              Player connected and data in cache
    - PlayerConnectedLoadDataCache: Player connected and data load in cache
    - PlayerNotConnected:           Player not connected to game center
    - Error:                        Error
    */
    class func getStateGameCenter() -> StateGameCenter {
        let state = EasyGameCenter.Static.instance!.stateOfGameCenter
        return state
    }
    /*____________________________ GameCenter Public LeaderBoard __________________________________________________*/
    /**
    Reports a  score to Game Center
    
    :param: The score Int
    :param: Leaderboard identifier
    :param: completion (bool) when the score is report to game center or Fail
    */
    class func reportScoreLeaderboard(#leaderboardIdentifier:String, score: Int,completion: ((result:Bool) -> Void)?) {
        
        
        if EasyGameCenter.isConnectedToNetwork() && EasyGameCenter.getStateGameCenter() == .PlayerConnected {
            
            let gameCenter = EasyGameCenter.Static.instance!
            if let scoreReporter =  gameCenter.scoresleaderBoard[leaderboardIdentifier] {
                let score64 = Int64(score)
                if score64 > scoreReporter.value {
                    scoreReporter.value = score64
                    scoreReporter.context = 0
                    scoreReporter.shouldSetDefaultLeaderboard = true
                    GKScore.reportScores([scoreReporter], {(error : NSError!) -> Void in
                        
                        if error != nil {
                            if completion != nil { completion!(result:false) }
                            println(error.localizedDescription)
                        } else {
                            completion!(result:true)
                        //    gameCenter.loadScores(completion: nil)
                        }
                        
                    })
                }
                
            }
            
            
            
        }
    }
    
    
    /*____________________________ GameCenter Public GKAchievement __________________________________________________*/
    /**
    Get Tuple ( GKAchievement , GKAchievementDescription) for identifier Achievement
    
    :param: achievementIdentifier Identifier Achievement
    
    :returns: (gkAchievement:GKAchievement,gkAchievementDescription:GKAchievementDescription)?
    */
    class func getTupleGKAchievementAndDescription(#achievementIdentifier:String) ->(gkAchievement:GKAchievement,gkAchievementDescription:GKAchievementDescription)? {
        let gameCenter = EasyGameCenter.sharedInstance
        
        if let achievementGKScore = gameCenter.achievementsCache[achievementIdentifier] {
          /*  if let achievementGKInformation = gameCenter.achievementsInformationCache[achievementIdentifier] {
                
                return (gkAchievement:achievementGKScore,gkAchievementDescription:achievementGKInformation)
                
                
            }*/
            
        }
        return nil
        
    }
    /**
    Get Achievement
    
    :param: identifierAchievement Identifier achievement
    
    :returns: GKAchievement Or nil if not exist
    */
    class func achievementForIndetifier(#identifierAchievement : NSString) -> GKAchievement? {
        let gameCenter = EasyGameCenter.Static.instance!
        
        if gameCenter.stateOfGameCenter == .PlayerConnected  {
            
            if let achievementFind = gameCenter.achievementsCache[identifierAchievement]? {
                return achievementFind
            } else {
                
                if  let achievementGet = GKAchievement(identifier: identifierAchievement) {
                    gameCenter.achievementsCache[identifierAchievement] = achievementGet
                    
                    /* recursive recall this func now that the achievement exist */
                    return EasyGameCenter.achievementForIndetifier(identifierAchievement: identifierAchievement)
                } else {
                    return nil
                }
            }
        }
        return nil
    }
    /**
    Add progress to an achievement
    
    :param: Progress achievement Double (ex: 10% = 10.00)
    :param: Achievement Identifier
    :param: if you want show banner when now or not when is completed
    */
    class func addProgressToAnAchievement( #progress : Double, achievementIdentifier : String, showBannnerIfCompleted : Bool) {
        
        if let achievement = EasyGameCenter.achievementForIndetifier(identifierAchievement: achievementIdentifier) {
            if !achievement.completed {
                achievement.percentComplete = progress
                
                /* show banner only if achievement is fully granted (progress is 100%) */
                if progress == 100.0 && showBannnerIfCompleted {
                    achievement.showsCompletionBanner = true
                }
                
                
                /* try to report the progress to the Game Center */
                GKAchievement.reportAchievements([achievement], withCompletionHandler:  {(var error:NSError!) -> Void in
                    
                    if error != nil {
                        println("Couldn't save achievement (\(achievementIdentifier)) progress to \(progress) %")
                    }
                })
            }
        }
    }
    /**
    If player is Identified to Game Center
    
    :returns: Bool True is identified
    */
    class func ifPlayerIdentifiedToGameCenter() -> Bool {
        let gameCenter = EasyGameCenter.Static.instance!
        
        if gameCenter.stateOfGameCenter == .PlayerConnected {
            return true
        }
        return false
        
    }
    
    /**
    If achievement is Finished
    
    :param: achievementIdentifier
    :return: Bool True is finished
    */
    class func ifAchievementCompleted(#achievementIdentifier: String) -> Bool{
        
        if let achievement = EasyGameCenter.achievementForIndetifier(identifierAchievement: achievementIdentifier) {
            if achievement.completed { return true }
            
        }
        
        return false
    }
    /**
    Get Achievement Complete if you have ( showBannerAchievementWhenComplete = false )
    Achievement Complete during the game and banner was not showing
    
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
    class func achievementCompleteAndBannerNotShowing() -> [String : GKAchievement]? {
        let achievements : [String:GKAchievement] = EasyGameCenter.Static.instance!.achievementsCache
        var achievementsTemps = [String:GKAchievement]()
        if achievements.count > 0 {
            
            for achievement in achievements  {
                
                var oneAchievement : GKAchievement = achievement.1
                
                if oneAchievement.completed && oneAchievement.showsCompletionBanner == false {
                    achievementsTemps[achievement.0] = achievement.1
                }
                
            }
        }
        return achievementsTemps
    }
    /**
    Show all save achievement Complete if you have ( showBannerAchievementWhenComplete = false )
    */
    class func showAllBannerAchievementCompleteForBannerNotShowing() {
        if let achievements : [String:GKAchievement] = EasyGameCenter.achievementCompleteAndBannerNotShowing() {
            
            for achievement in achievements  {
                
                var oneAchievement : GKAchievement = achievement.1
                if oneAchievement.completed {
                    print(oneAchievement.showsCompletionBanner)
                    oneAchievement.showsCompletionBanner = true
                    
                    if let tupleAchievementInformation = EasyGameCenter.getTupleGKAchievementAndDescription(achievementIdentifier: oneAchievement.identifier) {
                        
                        let title = tupleAchievementInformation.gkAchievementDescription.title
                        let description = tupleAchievementInformation.gkAchievementDescription.unachievedDescription
                        
                        EasyGameCenter.showBannerWithTitle(title: title, description: description, completion: nil)
                        
                    }
                    
                }
                
            }
        }
    }
    /**
    Show banner game center
    
    :param: title       title
    :param: description description
    :param: completion  if show message is showing
    */
    class func showBannerWithTitle(#title:String, description:String,completion: ((isShow:Bool) -> Void)?) {
        GKNotificationBanner.showBannerWithTitle(title, message: description, completionHandler: { () -> Void in
            if completion != nil { completion!(isShow:true) }
        })
    }
    /**
    Remove One Achievements
    
    :param: Achievement Identifier String
    */
    class func resetOneAchievement(#achievementIdentifier :String) {
        
        if let achievement = EasyGameCenter.achievementForIndetifier(identifierAchievement: achievementIdentifier) {
            GKAchievement.resetAchievementsWithCompletionHandler({ (var error:NSError!) ->
                Void in
                
                if error != nil {
                    println("Couldn't Reset achievement (\(achievementIdentifier))")
                    
                } else {
                    
                    achievement.percentComplete = 0
                    achievement.showsCompletionBanner = false
                    println("Reset achievement (\(achievementIdentifier))")
                }
                
            })
        }
    }
    
    /**
    Remove All Achievements
    */
    class func resetAllAchievements() {
        let gameCenter = EasyGameCenter.Static.instance!
        
        for lookupAchievement in gameCenter.achievementsCache {
            
            var achievementID = lookupAchievement.0
            EasyGameCenter.resetOneAchievement(achievementIdentifier: achievementID)
            
        }
    }
    /**
    Get SKScore
    
    :param: Leaderboard Identifier
    
    :returns: return GKScore
    */
    class func getScoreLeaderboard(#leaderboardIdentifier:String) -> GKScore? {
        let gameCenter = EasyGameCenter.sharedInstance
        if EasyGameCenter.getStateGameCenter() == .PlayerConnected  {
            if let scoreLeaderboard = gameCenter.scoresleaderBoard[leaderboardIdentifier] as GKScore? {
                return scoreLeaderboard
            }
        }
        return nil
    }
    /**
    CheckUp Connection the new
    
    :returns: Bool Connection Validation
    */
    class func isConnectedToNetwork() -> Bool {
        
        var zeroAddress = sockaddr_in(sin_len: 0, sin_family: 0, sin_port: 0, sin_addr: in_addr(s_addr: 0), sin_zero: (0, 0, 0, 0, 0, 0, 0, 0))
        zeroAddress.sin_len = UInt8(sizeofValue(zeroAddress))
        zeroAddress.sin_family = sa_family_t(AF_INET)
        
        let defaultRouteReachability = withUnsafePointer(&zeroAddress) {
            SCNetworkReachabilityCreateWithAddress(nil, UnsafePointer($0)).takeRetainedValue()
        }
        
        var flags: SCNetworkReachabilityFlags = 0
        if SCNetworkReachabilityGetFlags(defaultRouteReachability, &flags) == 0 {
            return false
        }
        
        let isReachable = (flags & UInt32(kSCNetworkFlagsReachable)) != 0
        let needsConnection = (flags & UInt32(kSCNetworkFlagsConnectionRequired)) != 0
        
        return (isReachable && !needsConnection) ? true : false
    }
    
}