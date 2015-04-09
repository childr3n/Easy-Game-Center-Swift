//
//  GameCenter.swift
//
//  Created by Yannick Stephan DaRk-_-D0G on 19/12/2014.
//  YannickStephan.com
//
//	iOS 8.0+
//
//  The MIT License (MIT)
//  Copyright (c) 2015 Red Wolf Studio & Yannick Stephan
//  http://www.redwolfstudio.fr
//  http://yannickstephan.com
//  Version 1.5

import Foundation
import GameKit
import SystemConfiguration

/**
*    Protocol Easy Game Center
*/
@objc protocol EasyGameCenterDelegate:NSObjectProtocol {
    /**
        Authentified, Delegate Easy Game Center
    */
    optional func easyGameCenterAuthentified()
    /**
        Not Authentified, Delegate Easy Game Center
    */
    optional func easyGameCenterNotAuthentified()
    /**
        Achievementes in cache, Delegate Easy Game Center
    */
    optional func easyGameCenterInCache()
}
/**
*    Extension of UIViewController, UIVC respect protocol
*/
extension UIViewController : EasyGameCenterDelegate {}
/**
*   Easy Game Center Swift
*/
class EasyGameCenter: NSObject, GKGameCenterControllerDelegate {
    
    /// Achievements GKAchievement Cache
    private var achievementsCache = [String:GKAchievement]()
    
    /// Achievements GKAchievementDescription Cache
    private var achievementsDescriptionCache = [String:GKAchievementDescription]()
    
    /// Save for report late when network working
    private var achievementsCacheShowAfter = [String:String]()
    
    /// Delegate UIViewController repect protocol EasyGameCenterDelegate
    private var delegateGetSetVC:EasyGameCenterDelegate?
    class var delegate: EasyGameCenterDelegate? {
        
        get {
            if let delegateVCIsOk = Static.instance!.delegateGetSetVC {
                return delegateVCIsOk
            }
            return nil
        }
        set {
            if EasyGameCenter.debugMode { println("\n/*****/\nDelegate UIViewController is \(_stdlib_getDemangledTypeName(newValue!)) (see viewDidAppear)\n/*****/\n") }
            /* If EasyGameCenter is start instance (for not instance Here) */
            if newValue != nil {
                if let instance = Static.instance {
                    let delegateVC = EasyGameCenter.delegate as? UIViewController
                    let newDelegateVC = newValue as? UIViewController
                    if newDelegateVC != delegateVC {
                        instance.delegateGetSetVC = newValue
                    }
                }
            }
        }
    }
    private var debugModeGetSet:Bool = false
    class var debugMode:Bool {
        get {
            return EasyGameCenter.sharedInstance()!.debugModeGetSet
        }
        set {
            EasyGameCenter.sharedInstance()!.debugModeGetSet = newValue
        }
    }
    /*####################################################################################################*/
    /*                                             Start                                                  */
    /*####################################################################################################*/
    /**
    Constructor
    
    */
    override init() { super.init() }
    /**
    Static EasyGameCenter
    
    */
    struct Static {
        /// Async EGC
        static var onceToken: dispatch_once_t = 0
        /// instance of EGC
        static var instance: EasyGameCenter? = nil
    }
    /**
    Start Singleton GameCenter Instance
    
    */
    class func sharedInstance(delegate:EasyGameCenterDelegate)-> EasyGameCenter {
        
        if Static.instance == nil {
            dispatch_once(&Static.onceToken) {
                Static.instance = EasyGameCenter()
                Static.instance!.delegateGetSetVC = delegate
                let priority = DISPATCH_QUEUE_PRIORITY_DEFAULT
                dispatch_async(dispatch_get_global_queue(priority, 0)) {
                   Static.instance!.loginPlayerToGameCenter()
                }
            }
        }
        
        return Static.instance!
    }
    /**
    ShareInstance Private
    
    :returns: EasyGameCenter or Nil
    */
    class private func sharedInstance() -> EasyGameCenter? {
        return EasyGameCenter.Static.instance?
    }
    private var inCacheIsLoading: Bool = false
    /**
    Load achievements in cache
    (Is call when you init EasyGameCenter, but if is fail example for cut connection, you can recall)
    And when you get Achievement or all Achievement, it shall automatically cached
    
    */
    func cachingAchievements() {
       
        if !self.inCacheIsLoading {
            self.inCacheIsLoading = true
            let priority = DISPATCH_QUEUE_PRIORITY_DEFAULT
            dispatch_async(dispatch_get_global_queue(priority, 0)) {
                if  EasyGameCenter.isConnectedToNetwork() &&
                    EasyGameCenter.isPlayerIdentifiedToGameCenter() {
                        
                        /* For the local player from Game Center */
                        GKAchievement.loadAchievementsWithCompletionHandler({
                            (var allAchievements:[AnyObject]!, error:NSError!) -> Void in
                            if error != nil {
                                dispatch_async(dispatch_get_main_queue()) {
                                    self.checkupNetAndPlayer()
                                }
                                if EasyGameCenter.debugMode { println("\nGame Center: could not load achievements, error: \(error)\n") }
                            }
                            /* Load Achievement with value pourcent */
                            for anAchievement in allAchievements  {
                                    if let oneAchievement = anAchievement as? GKAchievement {
                                        self.achievementsCache[oneAchievement.identifier] = oneAchievement}
                            }
                            
                            /* Get Description cache */
                            GKAchievementDescription.loadAchievementDescriptionsWithCompletionHandler {
                                (var achievementsDescription:[AnyObject]!, error:NSError!) -> Void in
                                
                                if error != nil {
                                    dispatch_async(dispatch_get_main_queue()) {
                                        self.checkupNetAndPlayer()
                                    }
                                    if EasyGameCenter.debugMode { println("\nGame Center: couldn't load achievementInformation, error: \(error)\n") }
                                }
                                
                                if let achievementsIsArrayGKAchievementDescription = achievementsDescription as? [GKAchievementDescription] {
                                    
                                    for gkAchievementDes in achievementsIsArrayGKAchievementDescription {
                                        
                                        /* Not ecrase Achievements with value pourcent */
                                        if self.achievementsCache[gkAchievementDes.identifier] == nil {
                                            if let gkAchievement = EasyGameCenter.achievementForIndentifier(identifierAchievement: gkAchievementDes.identifier) {
                                                self.achievementsCache[gkAchievementDes.identifier] = gkAchievement

                                            }
                                        }
                                        self.achievementsDescriptionCache[gkAchievementDes.identifier] = gkAchievementDes
                                    }
                                    if  self.achievementsCache.count > 0 &&
                                        self.achievementsDescriptionCache.count > 0 &&
                                        self.achievementsCache.count == self.achievementsDescriptionCache.count {
                                            EasyGameCenter.delegate!.easyGameCenterInCache?()
                                    } else {
                                        dispatch_async(dispatch_get_main_queue()) {
                                            self.checkupNetAndPlayer()
                                        }
                                    }
                                } else {
                                    dispatch_async(dispatch_get_main_queue()) {
                                        self.checkupNetAndPlayer()
                                    }
                                    
                                }
                                self.inCacheIsLoading = false
                            }
                        })
                } else {
                    self.inCacheIsLoading = false
                    dispatch_async(dispatch_get_main_queue()) {
                        self.checkupNetAndPlayer()
                    }
                }
            }
        }
    }
    /*####################################################################################################*/
    /*                          Private Func Login & Cache                                                */
    /*####################################################################################################*/
    /**
        Login player to GameCenter With Handler Authentification
        This function is recall When player connect to Game Center
    
        :param: completion (Bool) if player login to Game Center
    
    */
    private func loginPlayerToGameCenter()  {
            let delegate = EasyGameCenter.delegate
            let instanceEGC = EasyGameCenter.sharedInstance()
            if (delegate == nil || instanceEGC == nil) {
                if EasyGameCenter.debugMode { println("\nError : Delegate UIViewController not set\n") }
            } else {
                if !EasyGameCenter.isConnectedToNetwork() {
                    dispatch_async(dispatch_get_main_queue()) {
                        instanceEGC!.checkupNetAndPlayer()
                    }
                    
                    delegate!.easyGameCenterNotAuthentified?()
                    
                } else {
                    if EasyGameCenter.isPlayerIdentifiedToGameCenter() {
                        
                        dispatch_async(dispatch_get_main_queue()) {
                            instanceEGC!.cachingAchievements()
                        }
                        delegate!.easyGameCenterAuthentified?()
                        
                        
                    } else {
                        GKLocalPlayer.localPlayer().authenticateHandler = {
                            (var gameCenterVC:UIViewController!, var error:NSError!) -> Void in
                            
                            /* If got error / Or player not set value for login */
                            if error != nil {
                                dispatch_async(dispatch_get_main_queue()) {
                                    instanceEGC!.checkupNetAndPlayer()
                                }
                                delegate!.easyGameCenterNotAuthentified?()
                                
                                
                                /* Login to game center need Open page */
                            } else {
                                if gameCenterVC != nil {
                                    if let delegateController = delegate as? UIViewController {
                                        dispatch_async(dispatch_get_main_queue()) {
                                            delegateController.presentViewController(gameCenterVC!, animated: true, completion: nil)
                                        }
                                    } else {
                                        dispatch_async(dispatch_get_main_queue()) {
                                            instanceEGC!.checkupNetAndPlayer()
                                        }
                                        delegate!.easyGameCenterNotAuthentified?()
                                        
                                        if EasyGameCenter.debugMode { println("\nError : Delegate not set\n") }
                                    }
                                } else if EasyGameCenter.isPlayerIdentifiedToGameCenter() {
                                    
                                    dispatch_async(dispatch_get_main_queue()) {
                                        instanceEGC!.cachingAchievements()
                                    }
                                    delegate!.easyGameCenterAuthentified?()
                                    
                                    
                                } else  {
                                    dispatch_async(dispatch_get_main_queue()) {
                                        instanceEGC!.checkupNetAndPlayer()
                                    }
                                    delegate!.easyGameCenterNotAuthentified?()
                                    
                                }
                            }
                        }
                    }
                }
            }
    }
    /*####################################################################################################*/
    /*                              Private Timer checkup                                                 */
    /*####################################################################################################*/
    /// Checkup net and login to GameCenter when have Network
    private var timerNetAndPlayer:NSTimer?
    /**
    Function checkup when he have net work login Game Center
    */
    func checkupNetAndPlayer() {
        if self.timerNetAndPlayer == nil {
            self.timerNetAndPlayer = NSTimer.scheduledTimerWithTimeInterval(1.0, target: self, selector: Selector("checkupNetAndPlayer"), userInfo: nil, repeats: true)
        }
        
        if EasyGameCenter.isConnectedToNetwork() {
            self.timerNetAndPlayer!.invalidate()
            self.timerNetAndPlayer = nil
            
            let instanceEGC = EasyGameCenter.sharedInstance()
            if instanceEGC == nil {
                if EasyGameCenter.debugMode { println("\nError EasyGameCenter : Instance nil\n") }
            } else {
                instanceEGC!.loginPlayerToGameCenter()
            }
        }
    }
    /*####################################################################################################*/
    /*                                      Public Func Show                                              */
    /*####################################################################################################*/
    /**
    Show Game Center Player Achievements
    
    :param: completion Viod just if open Game Center Achievements
    */
    class func showGameCenterAchievements(completion: ((isShow:Bool) -> Void)? = nil) {
        let delegateUIVC = EasyGameCenter.delegate as? UIViewController
        let instance = Static.instance
        if (delegate == nil || instance == nil) {
            if EasyGameCenter.debugMode { println("Error EasyGameCenter : Delegate UIViewController not set") }
            if completion != nil { completion!(isShow:false) }
        } else {
            if EasyGameCenter.isConnectedToNetwork() && EasyGameCenter.isPlayerIdentifiedToGameCenter() {
                
                var gc = GKGameCenterViewController()
                gc.gameCenterDelegate = Static.instance!
                gc.viewState = GKGameCenterViewControllerState.Achievements
                
                delegateUIVC!.presentViewController(gc, animated: true, completion: {
                    () -> Void in
                    
                    if completion != nil { completion!(isShow:true) }
                })
                
            } else {
                if EasyGameCenter.debugMode { println("\nEasyGameCenter : Player not identified or not network\n") }
                if completion != nil { completion!(isShow:false) }
            }
        }
    }
    /**
    Show Game Center Leaderboard
    
    :param: leaderboardIdentifier Leaderboard Identifier
    :param: completion            Viod just if open Game Center Leaderboard
    */
    class func showGameCenterLeaderboard(#leaderboardIdentifier :String, completion: ((isShow:Bool) -> Void)? = nil) {
        let delegateUIVC = EasyGameCenter.delegate as? UIViewController
        let instance = Static.instance
        if (delegate == nil || instance == nil) {
            if EasyGameCenter.debugMode { println("\nError EasyGameCenter : Delegate UIViewController not set\n") }
        } else {
            if leaderboardIdentifier == "" {
                if EasyGameCenter.debugMode { println("\nError EasyGameCenter : (func showGameCenterLeaderboard )leaderboardIdentifier equal nul\n") }
            } else {
                if EasyGameCenter.isConnectedToNetwork() && EasyGameCenter.isPlayerIdentifiedToGameCenter() {
                    
                    var gc = GKGameCenterViewController()
                    gc.gameCenterDelegate = instance!
                    gc.leaderboardIdentifier = leaderboardIdentifier
                    gc.viewState = GKGameCenterViewControllerState.Leaderboards
                    
                    delegateUIVC!.presentViewController(gc, animated: true, completion: {
                        () -> Void in
                        
                        if completion != nil { completion!(isShow:true) }
                    })
                } else {
                    if EasyGameCenter.debugMode { println("\nEasyGameCenter : Player not identified or not network\n") }
                    if completion != nil { completion!(isShow:false) }
                }
            }
            
        }
    }
    /**
    Show Game Center Challenges
    
    :param: completion Viod just if open Game Center Challenges
    */
    class func showGameCenterChallenges(completion: ((isShow:Bool) -> Void)? = nil) {
        let delegateUIVC = EasyGameCenter.delegate as? UIViewController
        let instance = Static.instance
        if (delegate == nil || instance == nil) {
            if EasyGameCenter.debugMode { println("\nError EasyGameCenter : Delegate UIViewController not set\n") }
        } else {
            if EasyGameCenter.isConnectedToNetwork() && EasyGameCenter.isPlayerIdentifiedToGameCenter() {
                
                var gc = GKGameCenterViewController()
                gc.gameCenterDelegate =  instance!
                gc.viewState = GKGameCenterViewControllerState.Challenges
                
                delegateUIVC!.presentViewController(gc, animated: true, completion: {
                    () -> Void in
                    
                    if completion != nil { completion!(isShow:true) }
                })
            } else {
                if EasyGameCenter.debugMode { println("\nEasyGameCenter : Player not identified or not network\n") }
                if completion != nil { completion!(isShow:false) }
            }
        }
    }
    /**
    Show banner game center
    
    :param: title       title
    :param: description description
    :param: completion  When show message
    */
    class func showCustomBanner(#title:String, description:String,completion: (() -> Void)? = nil) {
        if EasyGameCenter.isPlayerIdentifiedToGameCenter() {
            
            GKNotificationBanner.showBannerWithTitle(title, message: description, completionHandler: {
                () -> Void in
                
                if completion != nil { completion!() }
            })
        } else {
            if EasyGameCenter.debugMode { println("\nEasyGameCenter : Player not identified\n") }
        }
        
    }
    /**
    Show page Authentication Game Center
    
    :param: completion Viod just if open Game Center Authentication
    */
    class func showGameCenterAuthentication(completion: ((result:Bool) -> Void)? = nil) {
        if completion != nil {
            completion!(result: UIApplication.sharedApplication().openURL(NSURL(string: "gamecenter:")!))
        }
    }
    /*####################################################################################################*/
    /*                                      Public Func Ohter                                             */
    /*####################################################################################################*/
    /**
    If player is Identified to Game Center
    
    :returns: Bool is identified
    
    */
    class func isPlayerIdentifiedToGameCenter() -> Bool { return GKLocalPlayer.localPlayer().authenticated }
    /**
    Get local player (GKLocalPlayer)
    
    :returns: Bool True is identified
    
    */
    class func getLocalPlayer() -> GKLocalPlayer { return GKLocalPlayer.localPlayer() }
    /*####################################################################################################*/
    /*                                      Public Func LeaderBoard                                       */
    /*####################################################################################################*/
    
    /**
    Get Leaderboards
    
    :param: completion return [GKLeaderboard] or nil
    
    Example:
    if let resultArrayGKLeaderboardIsOK = resultArrayGKLeaderboard as [GKLeaderboard]? {
    for oneGKLeaderboard in resultArrayGKLeaderboardIsOK  {
    }
    }
    */
    class func getGKLeaderboard(#completion: ((resultArrayGKLeaderboard:[GKLeaderboard]?) -> Void)) {
        
        let instanceEGC = EasyGameCenter.sharedInstance()
        if (instanceEGC == nil) {
            if EasyGameCenter.debugMode { println("\nError EasyGameCenter : Instance Nil\n") }
        } else {
            if EasyGameCenter.isPlayerIdentifiedToGameCenter() {
                    
                    GKLeaderboard.loadLeaderboardsWithCompletionHandler {
                        (var leaderboards:[AnyObject]!, error:NSError!) ->
                        Void in
                        
                        if error != nil { println("\nError EasyGameCenter : couldn't loadLeaderboards, error: \(error)\n") }
                        
                        if let leaderboardsIsArrayGKLeaderboard = leaderboards as? [GKLeaderboard] {
                            completion(resultArrayGKLeaderboard: leaderboardsIsArrayGKLeaderboard)
                            
                        } else {
                            completion(resultArrayGKLeaderboard: nil)
                        }
                    }
            } else {
                if EasyGameCenter.debugMode { println("\nEasyGameCenter : Player not identified or not network\n") }
            }
        }
    }
    /**
    Reports a  score to Game Center
    
    :param: The score Int
    :param: Leaderboard identifier
    :param: completion (bool) when the score is report to game center or Fail
    */
    class func reportScoreLeaderboard(#leaderboardIdentifier:String, score: Int) {
        
        if EasyGameCenter.isPlayerIdentifiedToGameCenter() {
                
                let gkScore = GKScore(leaderboardIdentifier: leaderboardIdentifier, player: EasyGameCenter.getLocalPlayer())
                gkScore.value = Int64(score)
                gkScore.shouldSetDefaultLeaderboard = true
                
                GKScore.reportScores([gkScore], withCompletionHandler: ( {
                    (error: NSError!) -> Void in
                    
                    if ((error) != nil) { /* Game Center Auto Save */ }
                }))
        } else {
            if EasyGameCenter.debugMode { println("\nEasyGameCenter : Player not identified \n") }
        }
    }
    
    class func getHighScore(#leaderboardIdentifier:String, completion:((playerName:String, score:Int,rank:Int)? -> Void)) {
        EasyGameCenter.getGKScoreLeaderboard(leaderboardIdentifier: leaderboardIdentifier, completion: {
            (resultGKScore) -> Void in
            if resultGKScore != nil {
                
                let rankVal = resultGKScore!.rank
                let nameVal  = EasyGameCenter.getLocalPlayer().alias
                let scoreVal  = Int(resultGKScore!.value)
                completion((playerName: nameVal, score: scoreVal, rank: rankVal))
                
            } else {
                completion(nil)
            }
        })
    }
    /**
    Get GKScoreOfLeaderboard
    
    :param: completion GKScore or nil
    */
    class func  getGKScoreLeaderboard(#leaderboardIdentifier:String, completion:((resultGKScore:GKScore?) -> Void)) {
        
        if EasyGameCenter.isPlayerIdentifiedToGameCenter() {
            
            let leaderBoardRequest = GKLeaderboard()
            leaderBoardRequest.identifier = leaderboardIdentifier
            
            leaderBoardRequest.loadScoresWithCompletionHandler {
                (resultGKScore, error) ->Void in
                
                if error != nil || resultGKScore == nil {
                    completion(resultGKScore: nil)
                    
                } else  {
                    completion(resultGKScore: leaderBoardRequest.localPlayerScore)
                    
                }
            }
        } else {
            completion(resultGKScore: nil)
        }
    }
    
    /*####################################################################################################*/
    /*                                      Public Func Achievements                                      */
    /*####################################################################################################*/
    /**
    Get Tuple ( GKAchievement , GKAchievementDescription) for identifier Achievement
    
    :param: achievementIdentifier Identifier Achievement
    
    :returns: (gkAchievement:GKAchievement,gkAchievementDescription:GKAchievementDescription)?
    */
    class func getTupleGKAchievementAndDescription(#achievementIdentifier:String,completion completionTuple: ((tupleGKAchievementAndDescription:(gkAchievement:GKAchievement,gkAchievementDescription:GKAchievementDescription)?) -> Void)
        ) {
            
            let instanceEGC = EasyGameCenter.sharedInstance()
            if instanceEGC == nil {
                completionTuple(tupleGKAchievementAndDescription: nil)
                if EasyGameCenter.debugMode { println("\nError : Instance Nil\n") }
            } else {
                let achievementGKScore = instanceEGC!.achievementsCache[achievementIdentifier]
                let achievementGKDes =  instanceEGC!.achievementsDescriptionCache[achievementIdentifier]
                
                if achievementGKScore != nil && achievementGKDes != nil {
                    completionTuple(tupleGKAchievementAndDescription: (achievementGKScore!,achievementGKDes!))
                } else {
                    if instanceEGC!.IfachievementIsReal(identifierAchievement: achievementIdentifier) {
                        instanceEGC!.cachingAchievements()
                    }
                    
                    EasyGameCenter.getTupleGKAchievementAndDescription(achievementIdentifier: achievementIdentifier, completion: {
                        (tupleGKAchievementAndDescription) -> Void in
                        completionTuple(tupleGKAchievementAndDescription: tupleGKAchievementAndDescription)
                    })
                }
            }
    }
    /**
    Get Achievement
    
    :param: identifierAchievement Identifier achievement
    
    :returns: GKAchievement Or nil if not exist
    */
    class func achievementForIndentifier(#identifierAchievement : NSString) -> GKAchievement? {
        
        let instanceEGC = EasyGameCenter.sharedInstance()
        if instanceEGC == nil {
            if EasyGameCenter.debugMode { println("\nError : Instance Nil\n") }
        } else {
            if EasyGameCenter.isPlayerIdentifiedToGameCenter()  {
                
                if let achievementFind = instanceEGC!.achievementsCache[identifierAchievement]? {
                    return achievementFind
                } else {
                    /* For not reset Achievement load with pourcent in loading */

                        if  let achievementIsOk = GKAchievement(identifier: identifierAchievement) {
                            instanceEGC!.achievementsCache[identifierAchievement] = achievementIsOk
                            instanceEGC!.cachingAchievements()
                            /* recursive recall this func now that the achievement exist */
                            return EasyGameCenter.achievementForIndentifier(identifierAchievement: identifierAchievement)
                            
                        } else {
                            if EasyGameCenter.debugMode { println("\nEasyGameCenter : Achievement ID \(identifierAchievement) is not real \n") }
                        }
                    
                }
            } else {
                if EasyGameCenter.debugMode { println("\nEasyGameCenter : Player not identified\n") }
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
    class func reportAchievement( #progress : Double, achievementIdentifier : String, showBannnerIfCompleted : Bool = true ,addToExisting: Bool = false) {
        
        let instanceEGC = EasyGameCenter.sharedInstance()
        if instanceEGC == nil {
            if EasyGameCenter.debugMode { println("\nError : Instance Nil\n") }
        } else {
            if let achievement = EasyGameCenter.achievementForIndentifier(identifierAchievement: achievementIdentifier) {
                
                var currentValue = achievement.percentComplete
                var newProgress: Double = !addToExisting ? progress : progress + currentValue
                
                achievement.percentComplete = newProgress
                
                /* show banner only if achievement is fully granted (progress is 100%) */
                if achievement.completed && showBannnerIfCompleted {
                    
                    if EasyGameCenter.isConnectedToNetwork() {
                        achievement.showsCompletionBanner = true
                    } else {
                        //oneAchievement.showsCompletionBanner = true << Bug For not show two banner
                        // Force show Banner when player not have network
                        EasyGameCenter.getTupleGKAchievementAndDescription(achievementIdentifier: achievementIdentifier, completion: {
                            (tupleGKAchievementAndDescription) -> Void in
                            
                            if let tupleIsOK = tupleGKAchievementAndDescription {
                                let title = tupleIsOK.gkAchievementDescription.title
                                let description = tupleIsOK.gkAchievementDescription.achievedDescription
                                
                                EasyGameCenter.showCustomBanner(title: title, description: description)
                            }
                        })
                    }
                }
                
                if  achievement.completed && !showBannnerIfCompleted {
                    instanceEGC!.achievementsCacheShowAfter[achievementIdentifier] = achievementIdentifier
                    
                }
                instanceEGC!.reportAchievementToGameCenter(achievement: achievement)
            }
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
    class func getGKAllAchievementDescription(#completion: ((arrayGKAD:[GKAchievementDescription]?) -> Void)){
        if EasyGameCenter.isPlayerIdentifiedToGameCenter() {
            if let gameCenterInstance = EasyGameCenter.sharedInstance() {
                if gameCenterInstance.achievementsDescriptionCache.count > 0 {
                    var tempsEnvoi = [GKAchievementDescription]()
                    for achievementDes in gameCenterInstance.achievementsDescriptionCache {
                        tempsEnvoi.append(achievementDes.1)
                    }
                    completion(arrayGKAD: tempsEnvoi)
                } else {
                    gameCenterInstance.cachingAchievements()
                }
            }
        } else {
            if EasyGameCenter.debugMode { println("\nEasyGameCenter : Player not identified or not network\n") }
            completion(arrayGKAD: nil)
        }
    }
    /**
    If achievement is Completed
    
    :param: Achievement Identifier
    :return: (Bool) if finished
    
    */
    class func isAchievementCompleted(#achievementIdentifier: String) -> Bool{
        if let achievement = EasyGameCenter.achievementForIndentifier(identifierAchievement: achievementIdentifier) {
            if achievement.completed || achievement.percentComplete == 100.00 {
                return true
            }
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
    class func getAchievementCompleteAndBannerNotShowing() -> [GKAchievement]? {
        let instanceEGC = EasyGameCenter.sharedInstance()
        if instanceEGC == nil {
            if EasyGameCenter.debugMode { println("\nError : Instance Nil\n") }
        } else {
            let achievements : [String:String] = instanceEGC!.achievementsCacheShowAfter
            var achievementsTemps = [GKAchievement]()
            
            if achievements.count > 0 {
                
                for achievement in achievements  {
                    let achievementExtract = EasyGameCenter.achievementForIndentifier(identifierAchievement: achievement.1)
                    achievementsTemps.append(achievementExtract!)
                }
                return achievementsTemps
            }
        }
        return nil
    }
    /**
    Show all save achievement Complete if you have ( showBannerAchievementWhenComplete = false )
    
    :param: completion if is Show Achievement banner
    (Bug Game Center if you show achievement by showsCompletionBanner = true when you report and again you show showsCompletionBanner = false is not show)
    
    */
    class func showAllBannerAchievementCompleteForBannerNotShowing(#completion: ((achievementShow:GKAchievement?) -> Void)?) {
        let instance = Static.instance
        if instance == nil {
            if EasyGameCenter.debugMode { println("\nError : Instance Nil\n") }
            completion!(achievementShow: nil)
        } else {
            if !EasyGameCenter.isPlayerIdentifiedToGameCenter() {
                if EasyGameCenter.debugMode { println("\nEasyGameCenter : Player not identified\n") }
                if completion != nil { completion!(achievementShow: nil) }
            } else {
                if let achievementNotShow: [GKAchievement] = EasyGameCenter.getAchievementCompleteAndBannerNotShowing() {
                    for achievement in achievementNotShow  {
                        
                        EasyGameCenter.getTupleGKAchievementAndDescription(achievementIdentifier: achievement.identifier, completion: {
                            (tupleGKAchievementAndDescription) -> Void in
                            
                            if let tupleOK = tupleGKAchievementAndDescription {
                                //oneAchievement.showsCompletionBanner = true
                                let title = tupleOK.gkAchievementDescription.title
                                let description = tupleOK.gkAchievementDescription.achievedDescription
                                
                                EasyGameCenter.showCustomBanner(title: title, description: description, completion: { () -> Void in
                                    if completion != nil { completion!(achievementShow: achievement) }
                                })
                                
                                
                            } else {
                                if completion != nil { completion!(achievementShow: nil) }
                            }
                        })
                    }
                    instance!.achievementsCacheShowAfter.removeAll(keepCapacity: false)
                } else {
                    if completion != nil { completion!(achievementShow: nil) }
                }
            }
        }
        
    }
    /**
    Get progress to an achievement
    
    :param: Achievement Identifier
    
    :returns: Double or nil (if not find)
    
    */
    class func getProgressForAchievement(#achievementIdentifier:String) -> Double? {
        let instanceEGC = EasyGameCenter.sharedInstance()
        if instanceEGC == nil {
            if EasyGameCenter.debugMode { println("\nError : Instance Nil\n") }
        } else {
            if EasyGameCenter.isPlayerIdentifiedToGameCenter() {
                if let achievementInArrayInt = instanceEGC!.achievementsCache[achievementIdentifier]?.percentComplete {
                    return achievementInArrayInt
                } else {
                    instanceEGC!.cachingAchievements()
                    return GKAchievement(identifier: achievementIdentifier).percentComplete
                }
            } else {
                if EasyGameCenter.debugMode { println("\nEasyGameCenter : Player not identified\n") }
            }
        }
        return nil
    }
    /**
        Remove All Achievements
    
        completion: return GKAchievement reset or Nil if game center not work
    */
    class func resetAllAchievements( completion:  ((achievementReset:GKAchievement?) -> Void)? = nil)  {
        
        if EasyGameCenter.isPlayerIdentifiedToGameCenter() {

            GKAchievement.resetAchievementsWithCompletionHandler({
                (var error:NSError!) -> Void in
                
                if error != nil {
                    if EasyGameCenter.debugMode { println("\n Couldn't Reset achievement (Send data error) \n") }
                    
                } else {
                    let gameCenter = EasyGameCenter.Static.instance!
                    for lookupAchievement in gameCenter.achievementsCache {
                        let achievementID = lookupAchievement.0
                        let achievementGK = lookupAchievement.1
                        achievementGK.percentComplete = 0
                        achievementGK.showsCompletionBanner = false
                        if completion != nil { completion!(achievementReset:achievementGK) }
                        if EasyGameCenter.debugMode { println("\nReset achievement (\(achievementID))\n") }
                    }
                }
            })
        } else {
            if completion != nil { completion!(achievementReset: nil) }
        }
    }
    /*####################################################################################################*/
    /*                                      Private Func Achievements                                     */
    /*####################################################################################################*/
    /**
    Report achievement classic
    
    :param: achievement GKAchievement
    */
    private func reportAchievementToGameCenter(#achievement:GKAchievement) {
        /* try to report the progress to the Game Center */
        GKAchievement.reportAchievements([achievement], withCompletionHandler:  {
            (var error:NSError!) -> Void in
            
            if error != nil { /* Game Center Save Automatique */ }
        })
    }
    /**
    If achievement is real
    
    :param: achievement Id
    */
    private func IfachievementIsReal(#identifierAchievement:String) -> Bool {
        if  let achievementGet = GKAchievement(identifier: identifierAchievement) {
            return true
        }
        return false
    }
    /*####################################################################################################*/
    /*                                      Public Func Internet                                          */
    /*####################################################################################################*/
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
    /*####################################################################################################*/
    /*                             Internal Delagate Game Center                                          */
    /*####################################################################################################*/
    /**
    Dismiss Game Center when player open
    :param: GKGameCenterViewController
    
    Override of GKGameCenterControllerDelegate
    */
    internal func gameCenterViewControllerDidFinish(gameCenterViewController: GKGameCenterViewController!) {
        gameCenterViewController.dismissViewControllerAnimated(true, completion: nil)
    }
}