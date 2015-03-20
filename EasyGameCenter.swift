//
//  GameCenter.swift
//
//  Created by Yannick Stephan DaRk-_-D0G on 19/12/2014.
//  YannickStephan.com
//
//	iOS 8.0+
//
//  CC0 1.0 Universal
//  For more information, please see
//  <http://creativecommons.org/publicdomain/zero/1.0/>


import Foundation
import GameKit
import SystemConfiguration


/**
    Easy Game Center Swift
*/
class EasyGameCenter: NSObject, GKGameCenterControllerDelegate {
    
    
    /// Achievements GKAchievement Cache
    private var achievementsCache = [String:GKAchievement]()

    
    /// ViewController MainView
    var delegate: UIViewController?

    
    /*_______________________________________ STARTER _______________________________________*/

    /**
        Static EasyGameCenter
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
            
        } else {
            completion!(resultConnectToGameCenter: GKLocalPlayer.localPlayer().authenticated)
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
    override init() {
        super.init()
    }
    /*____________________________ GameCenter Private Function __________________________________________________*/
    /**
        Login player to GameCenter With Handler Authentification
        This function is recall When player connect to Game Center
    
        :param: completion (Bool) if player login to Game Center
    */
    class func loginPlayerToGameCenter(#completion: ((result:Bool) -> Void)?)  {
        let gameCenter = EasyGameCenter.sharedInstance
        
        /* No Internet */
        if !EasyGameCenter.isConnectedToNetwork() {
            completion!(result: false)
            
        /* Yes Internet */
        } else {
            GKLocalPlayer.localPlayer().authenticateHandler = {(var gameCenterVC:UIViewController!, var error:NSError!) ->
                Void in
                
                /* If got error / Or player not set value for login */
                if error != nil {
                    
                    if completion != nil { completion!(result: false) }
                    
                } else {
                    
                    /* Login to game center need Open page */
                    if gameCenterVC != nil {
                        if let delegateController = gameCenter.delegate {
                            delegateController.presentViewController(gameCenterVC, animated: true, completion: nil)
                        } else {
                            println("\nError : Delegate for Easy Game Center not set\n")
                        }
                        
                    /* Login is ok */
                    } else if EasyGameCenter.isPlayerIdentifiedToGameCenter() == true {
                        
                        gameCenter.loadGKAchievement(completion: { (result) ->
                            Void in
                            
                            if completion != nil { completion!(result: EasyGameCenter.isPlayerIdentifiedToGameCenter()) }
                        })
                        
                    } else  {
                        
                        
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
        if EasyGameCenter.isConnectedToNetwork() && EasyGameCenter.isConnectedToNetwork() {
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



    /*____________________________ Other Methode Game Center __________________________________________________*/
    /**
        Show Game Center Player
    
        :param: completion isShow (Bool) if is show or not (example not connected)
    */
    class func showGameCenter(#completion: ((isShow:Bool) -> Void)?) {
 
        if EasyGameCenter.isPlayerIdentifiedToGameCenter() {
        let gameCenter = EasyGameCenter.Static.instance!
        if let delegateController = gameCenter.delegate {
                var gc = GKGameCenterViewController()
                gc.gameCenterDelegate = gameCenter
                delegateController.presentViewController(gc, animated: true, completion: {
                    () -> Void in
                    
                    if completion != nil { completion!(isShow:true) }
                })

            } else {
            if completion != nil { completion!(isShow:false) }
            }
        } else {
            if completion != nil { completion!(isShow:false) }
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
        Show banner game center
    
        :param: title       title
        :param: description description
        :param: completion  when show message
    */
    class func showBannerWithTitle(#title:String, description:String,completion: (() -> Void)?) {
        GKNotificationBanner.showBannerWithTitle(title, message: description, completionHandler: { () -> Void in
            if completion != nil { completion!() }
        })
    }
    /**
        Open page Authentication Game Center
    */
    class func openGameCenterAuthentication(#completion: ((result:Bool) -> Void)?) {
        if completion != nil {
            completion!(result: UIApplication.sharedApplication().openURL(NSURL(string: "gamecenter:")!))
        }
    }
    /**
        If player is Identified to Game Center
    
        :returns: Bool True is identified
    */
    class func isPlayerIdentifiedToGameCenter() -> Bool { return GKLocalPlayer.localPlayer().authenticated }

    /**
    If player is Identified to Game Center
    
    :returns: Bool True is identified
    */
    class func getLocalPlayer() -> GKLocalPlayer { return GKLocalPlayer.localPlayer() }
    /*____________________________ GameCenter Public LeaderBoard __________________________________________________*/
    
    /**
    Get Leaderboards
    
    :param: completion return [GKLeaderboard] or nil
    
    Example:
    for oneLeaderboard in arrayGKLeaderboard  {
    if let oneLeaderboardOK = oneLeaderboard as? GKLeaderboard {
    
    }
    }
    */
    class func getLeaderboards(#completion: ((result:[GKLeaderboard]?) -> Void)) {
        if EasyGameCenter.isConnectedToNetwork() && EasyGameCenter.isPlayerIdentifiedToGameCenter() {
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
        Reports a  score to Game Center
    
        :param: The score Int
        :param: Leaderboard identifier
        :param: completion (bool) when the score is report to game center or Fail
    */
    class func reportScoreLeaderboard(#leaderboardIdentifier:String, score: Int,completion: ((result:Bool) -> Void)?) {
        
        
        if EasyGameCenter.isConnectedToNetwork() && EasyGameCenter.isPlayerIdentifiedToGameCenter() {
            
            let gameCenter = EasyGameCenter.sharedInstance
              // }
            
            
            // if player is logged in to GC, then report the score
            if GKLocalPlayer.localPlayer().authenticated {
                let gkScore = GKScore(leaderboardIdentifier: leaderboardIdentifier)
                
                gkScore.value = Int64(score)
                gkScore.shouldSetDefaultLeaderboard = true
                
                GKScore.reportScores([gkScore], withCompletionHandler: ( { (error: NSError!) -> Void in
                    if (error != nil) {
                        if completion != nil { completion!(result:false) }
                    } else {
                        if completion != nil { completion!(result:true) }
                    }
                }))
            }
            
        }
    }
    /**
        Show Game Center Leaderboard passed as string into func
    
        :param: leaderboard Identifier
    */
    class func showGameCenterLeaderboard(#leaderboardIdentifier :String) {
        
        if EasyGameCenter.isPlayerIdentifiedToGameCenter() && leaderboardIdentifier != "" {
            let gameCenter = EasyGameCenter.sharedInstance
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
        Get GKScoreOfLeaderboard
    
        :param: completion GKScore or nil
    */
    class func  getGKScoreOfLeaderboard(#leaderboardIdentifier:String, completion: ((result:GKScore?) -> Void)) {
        
        if EasyGameCenter.isConnectedToNetwork() && EasyGameCenter.isPlayerIdentifiedToGameCenter() {
            let leaderBoardRequest = GKLeaderboard()
            leaderBoardRequest.identifier = leaderboardIdentifier
            leaderBoardRequest.loadScoresWithCompletionHandler {
                (resultGKScore, error) ->Void in
                
                if error != nil || resultGKScore == nil {
                    completion(result: nil)
                    
                } else  {
                    completion(result: leaderBoardRequest.localPlayerScore)
                    
                }
            }
        }
    }
    
    /*____________________________ Achievement __________________________________________________*/

    /**
        Get Tuple ( GKAchievement , GKAchievementDescription) for identifier Achievement
    
        :param: achievementIdentifier Identifier Achievement
    
        :returns: (gkAchievement:GKAchievement,gkAchievementDescription:GKAchievementDescription)?
    */
    class func getTupleGKAchievementAndDescription(#achievementIdentifier:String,completion: (
        (tupleGKAchievementAndDescription:(gkAchievement:GKAchievement,gkAchievementDescription:GKAchievementDescription)?) -> Void)
        ) {
        let gameCenter = EasyGameCenter.sharedInstance
        
        if let achievementGKScore = gameCenter.achievementsCache[achievementIdentifier] {
            
            EasyGameCenter.getGKAchievementDescription(completion: { (arrayGKAD) -> Void in
                
                if let arrayGKADIsOK = arrayGKAD {
                    completion(tupleGKAchievementAndDescription: (achievementGKScore,arrayGKADIsOK[0]))
                } else {
                    completion(tupleGKAchievementAndDescription: nil)
                }
                
            })
          /*  if let achievementGKInformation = gameCenter.achievementsInformationCache[achievementIdentifier] {
                
                return (gkAchievement:achievementGKScore,gkAchievementDescription:achievementGKInformation)
                
                
            }*/
            
        }
        //return nil
        
    }
    /**
    Get Achievement
    
    :param: identifierAchievement Identifier achievement
    
    :returns: GKAchievement Or nil if not exist
    */
    class func achievementForIndetifier(#identifierAchievement : NSString) -> GKAchievement? {
        let gameCenter = EasyGameCenter.sharedInstance
        
        if EasyGameCenter.isPlayerIdentifiedToGameCenter()  {
            
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
    
        :param: progress               Progress achievement Double (ex: 10% = 10.00)
        :param: achievementIdentifier  Achievement Identifier
        :param: showBannnerIfCompleted if you want show banner when now or not when is completed
        :param: completionIsSend       Completion if is send to Game Center
    */
    class func reportAchievements( #progress : Double, achievementIdentifier : String, showBannnerIfCompleted : Bool,completionIsSend: ((isSendToGameCenterOrNor:Bool) -> Void)?) {
        
        if let achievement = EasyGameCenter.achievementForIndetifier(identifierAchievement: achievementIdentifier) {
            if !achievement.completed {
                achievement.percentComplete = progress
                
                /* show banner only if achievement is fully granted (progress is 100%) */
                if progress == 100.0 && showBannnerIfCompleted {
                    achievement.showsCompletionBanner = true
                }
                
                
                /* try to report the progress to the Game Center */
                GKAchievement.reportAchievements([achievement], withCompletionHandler:  {(var error:NSError!) -> Void in
                    
                    var validation = false
                    
                    if error != nil {
                        println("Couldn't save achievement (\(achievementIdentifier)) progress to \(progress) %")
                        
                    } else {
                        validation = true
                       
                    }
                    
                    if completionIsSend != nil { completionIsSend!(isSendToGameCenterOrNor: validation) }
                })
            } else {
               if completionIsSend != nil { completionIsSend!(isSendToGameCenterOrNor: false) }
            }
        } else {
            if completionIsSend != nil { completionIsSend!(isSendToGameCenterOrNor: false) }
        }
    }
    /**
    Get GKAchievementDescription
    
    :param: completion return array [GKAchievementDescription] or nil
    
    Example:
    for achievement in arrayGKAchievementDescription  {
    if let oneAchievementDes = achievement as? GKAchievementDescription {
    
    }
    }
    */
    class func getGKAchievementDescription(#completion: ((arrayGKAD:[GKAchievementDescription]?) -> Void)){
        if EasyGameCenter.isConnectedToNetwork() && EasyGameCenter.isPlayerIdentifiedToGameCenter() {
            GKAchievementDescription.loadAchievementDescriptionsWithCompletionHandler {
                (var achievementsDescription:[AnyObject]!, error:NSError!) -> Void in
                
                if error != nil {
                    println("Game Center: couldn't load achievementInformation, error: \(error)")
                }
                if let achievementsIsArrayGKAchievementDescription = achievementsDescription as? [GKAchievementDescription] {
                    completion(arrayGKAD: achievementsIsArrayGKAchievementDescription)
                    
                } else {
                    completion(arrayGKAD: nil)
                }
            }
        } else {
            completion(arrayGKAD: nil)
        }
        
    }

    /**
        If achievement is Completed
    
        :param: Achievement Identifier
        :return: (Bool) if finished
    */
    class func isAchievementCompleted(#achievementIdentifier: String) -> Bool{
        
        if let achievement = EasyGameCenter.achievementForIndetifier(identifierAchievement: achievementIdentifier) {
            if achievement.completed { return true }
            
        }
        
        return false
    }
    /**
        Get Achievements Completes during the game and banner was not showing
    
        Example :
            if let achievements : [String:GKAchievement] = EasyGameCenter.getAchievementCompleteAndBannerNotShowing() {
                for achievement in achievements  {
                    var oneAchievement : GKAchievement = achievement.1
                    if oneAchievement.completed {
                        oneAchievement.showsCompletionBanner = true
                    }
                }
            }
    
    :returns: [String : GKAchievement] or nil
    */
    class func getAchievementCompleteAndBannerNotShowing() -> [String : GKAchievement]? {
        let achievements : [String:GKAchievement] = EasyGameCenter.sharedInstance.achievementsCache
        var achievementsTemps = [String:GKAchievement]()
        if achievements.count > 0 {
            
            for achievement in achievements  {
                
                var oneAchievement : GKAchievement = achievement.1
                
                if oneAchievement.completed && oneAchievement.showsCompletionBanner == false {
                    achievementsTemps[achievement.0] = achievement.1
                }
                
            }
            return achievementsTemps
        }
        return nil
        
    }
    /**
        Show all save achievement Complete if you have ( showBannerAchievementWhenComplete = false )
    */
    class func showAllBannerAchievementCompleteForBannerNotShowing(#completion: ((isShowAchievement:Bool) -> Void)?) {
        
        if isPlayerIdentifiedToGameCenter() && isConnectedToNetwork() {
            if let achievements : [String:GKAchievement] = EasyGameCenter.getAchievementCompleteAndBannerNotShowing() {
                
                for achievement in achievements  {
                    
                    var oneAchievement : GKAchievement = achievement.1
                    if oneAchievement.showsCompletionBanner == false {
                        oneAchievement.showsCompletionBanner = true
                        EasyGameCenter.getTupleGKAchievementAndDescription(achievementIdentifier: oneAchievement.identifier, completion: {
                            (tupleGKAchievementAndDescription) -> Void in
                            
                            if let tupleOK = tupleGKAchievementAndDescription {
                                
                                let title = tupleOK.gkAchievementDescription.title
                                let description = tupleOK.gkAchievementDescription.achievedDescription
                                
                                EasyGameCenter.showBannerWithTitle(title: title, description: description, completion: { () -> Void in
                                    if completion != nil { completion!(isShowAchievement: true) }
                                })
                                
                                
                            } else {
                                if completion != nil { completion!(isShowAchievement: false) }
                            }
                        })
                    }
                }
            } else {
                if completion != nil { completion!(isShowAchievement: false) }
            }

        } else {
            if completion != nil { completion!(isShowAchievement: false) }
        }
    }

    class func progressForAchievement(#achievementIdentifier:String) -> Double? {
        if EasyGameCenter.isPlayerIdentifiedToGameCenter() {
            if let achievementInArrayInt = EasyGameCenter.sharedInstance.achievementsCache[achievementIdentifier]?.percentComplete {
                return achievementInArrayInt
            }
        }
        return nil
    }
    /**
        Remove One Achievements

        :param: Achievement Identifier
        :param: completion  If achievement is reset to Game Center server
    */
    class func resetOneAchievement(#achievementIdentifier :String, completion: ((isResetToGameCenterOrNor:Bool) -> Void)?) {
        if EasyGameCenter.isConnectedToNetwork() && EasyGameCenter.isPlayerIdentifiedToGameCenter() {
            if let achievement = EasyGameCenter.achievementForIndetifier(identifierAchievement: achievementIdentifier) {
                GKAchievement.resetAchievementsWithCompletionHandler({
                    (var error:NSError!) -> Void in
                    
                    var validation = false
                    if error != nil {
                        println("Couldn't Reset achievement (\(achievementIdentifier))")
                        
                    } else {
                        achievement.percentComplete = 0
                        achievement.showsCompletionBanner = false
                        validation = true
                        println("Reset achievement (\(achievementIdentifier))")
                        
                    }
                    if completion != nil { completion!(isResetToGameCenterOrNor: validation) }
                    
                })
            }
        }
    }
    
    /**
        Remove All Achievements
    */
    class func resetAllAchievements( completion:  ((achievementNotReset:GKAchievement) -> Void)?)  {
        
        if EasyGameCenter.isConnectedToNetwork() && EasyGameCenter.isPlayerIdentifiedToGameCenter() {
            let gameCenter = EasyGameCenter.Static.instance!
            
            for lookupAchievement in gameCenter.achievementsCache {
                
                var achievementID = lookupAchievement.0
                EasyGameCenter.resetOneAchievement(achievementIdentifier: achievementID, completion: {
                    (isReset) -> Void in
                    if !isReset {
                        
                        if completion != nil {
                            completion!(achievementNotReset:lookupAchievement.1)
                        }
                    }
                })
                
            }
        }

    }


    /*_______________________________ Internet _______________________________________________*/
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
    /*_______________________________ Internal Delagate _______________________________________________*/
    /**
        Dismiss Game Center when player open
        :param: GKGameCenterViewController
    
        Override of GKGameCenterControllerDelegate
    */
    internal func gameCenterViewControllerDidFinish(gameCenterViewController: GKGameCenterViewController!) {
        gameCenterViewController.dismissViewControllerAnimated(true, completion: nil)
    }
}