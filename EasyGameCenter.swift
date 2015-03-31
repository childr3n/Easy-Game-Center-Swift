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
//  Version 1.1

import Foundation
import GameKit
import SystemConfiguration

/**
*    Protocol Easy Game Center
*/
@objc protocol EasyGameCenterDelegate:NSObjectProtocol {
    optional func easyGameCenterAuthentified()
    optional func easyGameCenterNotAuthentified()
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
        static var onceToken: dispatch_once_t = 0
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
                Static.instance!.loginPlayerToGameCenter()
            }
        }
        
        return Static.instance!
    }
    /*####################################################################################################*/
    /*                                      Private Func                                                  */
    /*####################################################################################################*/
    /**
    Login player to GameCenter With Handler Authentification
    This function is recall When player connect to Game Center
    
    :param: completion (Bool) if player login to Game Center
    */
    private func loginPlayerToGameCenter()  {
        let delegate = EasyGameCenter.delegate
        let instance = Static.instance
        if (delegate == nil || instance == nil) {
            println("\nError : Delegate UIViewController not set\n")
        } else {
            if !EasyGameCenter.isConnectedToNetwork() {
                delegate!.easyGameCenterNotAuthentified?()
                instance!.checkupNetAndPlayer()
            } else {
                if EasyGameCenter.isPlayerIdentifiedToGameCenter() {
                    
                    delegate!.easyGameCenterAuthentified?()
                    
                } else {
                    GKLocalPlayer.localPlayer().authenticateHandler = {
                        (var gameCenterVC:UIViewController!, var error:NSError!) -> Void in
                        
                        /* If got error / Or player not set value for login */
                        if error != nil {
                            delegate!.easyGameCenterNotAuthentified?()
                            instance!.checkupNetAndPlayer()
                            
                            /* Login to game center need Open page */
                        } else {
                            if gameCenterVC != nil {
                                if let delegateController = delegate as? UIViewController {
                                    delegateController.presentViewController(gameCenterVC, animated: true, completion: nil)
                                } else {
                                    EasyGameCenter.delegate!.easyGameCenterNotAuthentified?()
                                    instance!.checkupNetAndPlayer()
                                    println("\nError : Delegate set\n")
                                }
                                
                                /* Login is ok */
                            } else if EasyGameCenter.isPlayerIdentifiedToGameCenter() {
                                
                                delegate!.easyGameCenterAuthentified?()
                                
                                instance!.loadGKAchievement()
                                
                            } else  {
                                delegate!.easyGameCenterNotAuthentified?()
                                instance!.checkupNetAndPlayer()
                                
                            }
                        }
                    }
                }
            }
        }
    }
    /**
    Load achievements in cache
    (Is call when you init EasyGameCenter, but if is fail example for cut connection, you can recall)
    And when you get Achievement or all Achievement, it shall automatically cached
    
    :param: completion (Bool) achievements in cache
    */
    private func loadGKAchievement() {
        
        let instance = Static.instance
        let delegate = EasyGameCenter.delegate
        if (instance == nil || delegate == nil) {
            println("\nError : Delegate UIViewController not set\n")
        } else {
            if  EasyGameCenter.isConnectedToNetwork() &&
                EasyGameCenter.isPlayerIdentifiedToGameCenter() {
                    
                    GKAchievement.loadAchievementsWithCompletionHandler({
                        (var achievements:[AnyObject]!, error:NSError!) -> Void in
                        if error != nil {
                            println("\nGame Center: could not load achievements, error: \(error)\n")
                            
                        } else {
                            
                            if achievements != nil {
                                
                                for achievement in achievements  {
                                    if let oneAchievement = achievement as? GKAchievement {
                                        self.achievementsCache[oneAchievement.identifier] = oneAchievement
                                        
                                        EasyGameCenter.getTupleGKAchievementAndDescription(achievementIdentifier: oneAchievement.identifier, completion: { (tupleGKAchievementAndDescription) -> Void in
                                            if let achievementTuple = tupleGKAchievementAndDescription {
                                                
                                                self.achievementsDescriptionCache[oneAchievement.identifier] = achievementTuple.gkAchievementDescription
                                            }
                                            
                                        })
                                    }
                                }
                                delegate!.easyGameCenterInCache?()
                            } else {
                                self.checkupInCache()
                            }
                        }
                    })
            } else {
                println("\nEasyGameCenter : Player not identified or not network\n")
            }
        }
    }
    /*####################################################################################################*/
    /*                              Private Timer checkup                                                 */
    /*####################################################################################################*/
    /// Checkup net et Game Center
    private var timerInCache:NSTimer?
    private func checkupInCache() {
        
        if self.timerInCache == nil {
            self.timerInCache = NSTimer.scheduledTimerWithTimeInterval(1.0, target: self, selector: Selector("checkupInCache"), userInfo: nil, repeats: true)
        }
        
        if EasyGameCenter.isConnectedToNetwork() {
            self.timerInCache!.invalidate()
            self.timerInCache = nil
            self.loadGKAchievement()
        }
    }
    /// Checkup net et Game Center
    private var timerNetAndPlayer:NSTimer?
    private func checkupNetAndPlayer() {
        
        if self.timerNetAndPlayer == nil {
            self.timerNetAndPlayer = NSTimer.scheduledTimerWithTimeInterval(1.0, target: self, selector: Selector("checkupNetAndPlayer"), userInfo: nil, repeats: true)
        }
        
        if EasyGameCenter.isConnectedToNetwork() {
            self.timerNetAndPlayer!.invalidate()
            self.timerNetAndPlayer = nil
            
            let instance = Static.instance
            if instance == nil {
                println("\nError EasyGameCenter : Instance nil\n")
            } else {
                instance!.loginPlayerToGameCenter()
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
    class func showGameCenterAchievements(#completion: ((isShow:Bool) -> Void)?) {
        let delegateUIVC = EasyGameCenter.delegate as? UIViewController
        let instance = Static.instance
        if (delegate == nil || instance == nil) {
            println("Error EasyGameCenter : Delegate UIViewController not set")
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
                println("\nEasyGameCenter : Player not identified or not network\n")
                if completion != nil { completion!(isShow:false) }
            }
        }
    }
    /**
    Show Game Center Leaderboard
    
    :param: leaderboardIdentifier Leaderboard Identifier
    :param: completion            Viod just if open Game Center Leaderboard
    */
    class func showGameCenterLeaderboard(#leaderboardIdentifier :String, completion: (() -> Void)?) {
        let delegateUIVC = EasyGameCenter.delegate as? UIViewController
        let instance = Static.instance
        if (delegate == nil || instance == nil) {
            println("\nError EasyGameCenter : Delegate UIViewController not set\n")
        } else {
            if leaderboardIdentifier == "" {
                println("\nError EasyGameCenter : (func showGameCenterLeaderboard )leaderboardIdentifier equal nul\n")
            } else {
                if EasyGameCenter.isPlayerIdentifiedToGameCenter() {
                    
                    var gc = GKGameCenterViewController()
                    gc.gameCenterDelegate = instance!
                    gc.leaderboardIdentifier = leaderboardIdentifier
                    gc.viewState = GKGameCenterViewControllerState.Leaderboards
                    
                    delegateUIVC!.presentViewController(gc, animated: true, completion: { () ->
                        Void in
                        
                        if completion != nil { completion!() }
                        
                    })
                } else {
                    println("\nEasyGameCenter : Player not identified\n")
                }
            }
            
        }
    }
    /**
    Show Game Center Challenges
    
    :param: completion Viod just if open Game Center Challenges
    */
    class func showGameCenterChallenges(#completion: (() -> Void)?) {
        let delegateUIVC = EasyGameCenter.delegate as? UIViewController
        let instance = Static.instance
        if (delegate == nil || instance == nil) {
            println("\nError EasyGameCenter : Delegate UIViewController not set\n")
        } else {
            if EasyGameCenter.isPlayerIdentifiedToGameCenter() {
                
                var gc = GKGameCenterViewController()
                gc.gameCenterDelegate =  instance!
                gc.viewState = GKGameCenterViewControllerState.Challenges
                
                delegateUIVC!.presentViewController(gc, animated: true, completion: {
                    () -> Void in
                    
                    if completion != nil { completion!() }
                })
            } else {
                println("\nEasyGameCenter : Player not identified\n")
            }
        }
    }
    /**
    Open Dialog for player see he wasn't authentifate to Game Center and can go to login
    
    :param: titre                     Title
    :param: message                   Message
    :param: buttonOK                  Title of button OK
    :param: buttonOpenGameCenterLogin Title of button open Game Center
    :param: completion                Completion if player open Game Center Authentification
    */
    class func openDialogGameCenterAuthentication(#titre:String, message:String,buttonOK:String,buttonOpenGameCenterLogin:String, completion: ((openGameCenterAuthentification:Bool) -> Void)?) {
        let delegateUIVC = EasyGameCenter.delegate as? UIViewController
        let instance = Static.instance
        if (delegate == nil || instance == nil) {
            println("\nError EasyGameCenter : Delegate UIViewController not set\n")
        } else {
            var alert = UIAlertController(title: titre, message: message, preferredStyle: UIAlertControllerStyle.ActionSheet)
            
            alert.popoverPresentationController?.sourceView = delegateUIVC!.view as UIView
            
            delegateUIVC!.presentViewController(alert, animated: true, completion: nil)
            
            alert.addAction(UIAlertAction(title: buttonOK, style: .Default, handler: {
                action in
                
                if completion != nil { completion!(openGameCenterAuthentification: false) }
                
            }))
            
            alert.addAction(UIAlertAction(title: buttonOpenGameCenterLogin, style: .Default, handler: {
                action in
                
                EasyGameCenter.showGameCenterAuthentication(completion: {
                    (resultOpenGameCenter) -> Void in
                    
                    if completion != nil { completion!(openGameCenterAuthentification: resultOpenGameCenter) }
                })
                
            }))
        }
    }
    /**
    Show banner game center
    
    :param: title       title
    :param: description description
    :param: completion  When show message
    */
    class func showCustomBanner(#title:String, description:String,completion: (() -> Void)?) {
        if EasyGameCenter.isPlayerIdentifiedToGameCenter() {
            
            GKNotificationBanner.showBannerWithTitle(title, message: description, completionHandler: {
                () -> Void in
                
                if completion != nil { completion!() }
            })
        } else {
            println("\nEasyGameCenter : Player not identified\n")
        }
        
    }
    /**
    Show page Authentication Game Center
    
    :param: completion Viod just if open Game Center Authentication
    */
    class func showGameCenterAuthentication(#completion: ((result:Bool) -> Void)?) {
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
    /**
    Is have network and player identified to Game Center
    
    :returns: (Bool)
    */
    class func isHaveNetworkAndPlayerIdentified() -> Bool {
        return ( EasyGameCenter.isConnectedToNetwork() && EasyGameCenter.isPlayerIdentifiedToGameCenter() )
    }
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
        
        let instance = Static.instance
        if (instance == nil) {
            println("\nError EasyGameCenter : Instance Nil\n")
        } else {
            if  EasyGameCenter.isConnectedToNetwork() &&
                EasyGameCenter.isPlayerIdentifiedToGameCenter() {
                    
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
                println("\nEasyGameCenter : Player not identified or not network\n")
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
        
        if EasyGameCenter.isConnectedToNetwork() && EasyGameCenter.isPlayerIdentifiedToGameCenter() {
            
            if GKLocalPlayer.localPlayer().authenticated {
                
                let gkScore = GKScore(leaderboardIdentifier: leaderboardIdentifier, player: EasyGameCenter.getLocalPlayer())
                gkScore.value = Int64(score)
                gkScore.shouldSetDefaultLeaderboard = true
                
                
                GKScore.reportScores([gkScore], withCompletionHandler: ( {
                    (error: NSError!) -> Void in
                    
                    if ((error) != nil) {
                        // Not
                        
                    } else {
                        //  OK
                        
                    }
                }))
            }
        } else {
            println("\nEasyGameCenter : Player not identified or not network\n")
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
        
        if EasyGameCenter.isHaveNetworkAndPlayerIdentified() {
            
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
            
            let instance = Static.instance
            if instance == nil {
                println("\nError : Instance Nil\n")
            } else {
                
                if let achievementGKScore = instance!.achievementsCache[achievementIdentifier] {
                    if let achievementDes =  instance!.achievementsDescriptionCache[achievementIdentifier] {
                        completionTuple(tupleGKAchievementAndDescription: (achievementGKScore,achievementDes))
                    } else {
                        EasyGameCenter.getGKAllAchievementDescription(completion: {
                            (arrayGKAD) -> Void in
                            
                            if let arrayGKADIsOK = arrayGKAD as [GKAchievementDescription]? {
                                var find = false
                                
                                for oneAchievement in arrayGKADIsOK {
                                    if oneAchievement.identifier == achievementIdentifier {
                                        find = true
                                        completionTuple(tupleGKAchievementAndDescription: (achievementGKScore,oneAchievement))
                                    }
                                }
                                
                                if !find { completionTuple(tupleGKAchievementAndDescription: nil) }
                                
                            } else { completionTuple(tupleGKAchievementAndDescription: nil) }
                            
                        })
                    }
                    
                } else { completionTuple(tupleGKAchievementAndDescription: nil) }
                
            }
    }
    /**
    Get Achievement
    
    :param: identifierAchievement Identifier achievement
    
    :returns: GKAchievement Or nil if not exist
    */
    class func achievementForIndentifier(#identifierAchievement : NSString) -> GKAchievement? {
        
        let instance = Static.instance
        if instance == nil {
            println("\nError : Instance Nil\n")
        } else {
            if EasyGameCenter.isPlayerIdentifiedToGameCenter()  {
                
                if let achievementFind = instance!.achievementsCache[identifierAchievement]? {
                    return achievementFind
                } else {
                    
                    if  let achievementGet = GKAchievement(identifier: identifierAchievement) {
                        instance!.achievementsCache[identifierAchievement] = achievementGet
                        
                        /* recursive recall this func now that the achievement exist */
                        return EasyGameCenter.achievementForIndentifier(identifierAchievement: identifierAchievement)
                    }
                }
            } else {
                println("\nEasyGameCenter : Player not identified\n")
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
    
    class func reportAchievement( #progress : Double, achievementIdentifier : String, showBannnerIfCompleted : Bool) {
        
        let instance = Static.instance
        if instance == nil {
            println("\nError : Instance Nil\n")
        } else {
            if let achievement = EasyGameCenter.achievementForIndentifier(identifierAchievement: achievementIdentifier) {
                achievement.percentComplete = progress
                
                /* show banner only if achievement is fully granted (progress is 100%) */
                if achievement.completed && showBannnerIfCompleted {
                    
                    achievement.showsCompletionBanner = true
                }
                if  achievement.completed && !showBannnerIfCompleted {
                    
                    if instance!.achievementsCacheShowAfter[achievementIdentifier] == nil {
                        instance!.achievementsCacheShowAfter[achievementIdentifier] = achievementIdentifier
                    }
                    
                }
                instance!.reportAchievementToGameCenter(achievement)
            }
        }
        
    }
    
    private func reportAchievementToGameCenter(achievement:GKAchievement) {
        /* try to report the progress to the Game Center */
        GKAchievement.reportAchievements([achievement], withCompletionHandler:  {
            (var error:NSError!) -> Void in
            
            if error != nil {
                println("\nCouldn't save achievement (\(achievement.identifier)) progress to \(achievement.percentComplete) %\n")
                
            }
        })
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
        if EasyGameCenter.isConnectedToNetwork() && EasyGameCenter.isPlayerIdentifiedToGameCenter() {
            GKAchievementDescription.loadAchievementDescriptionsWithCompletionHandler {
                (var achievementsDescription:[AnyObject]!, error:NSError!) -> Void in
                
                if error != nil { println("\nGame Center: couldn't load achievementInformation, error: \(error)\n")
                } else {
                    if let achievementsIsArrayGKAchievementDescription = achievementsDescription as? [GKAchievementDescription] {
                        completion(arrayGKAD: achievementsIsArrayGKAchievementDescription)
                        
                    } else { completion(arrayGKAD: nil) }
                }
                
            }
        } else {
            println("\nEasyGameCenter : Player not identified or not network\n")
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
        let instance = Static.instance
        if instance == nil {
            println("\nError : Instance Nil\n")
        } else {
            let achievements : [String:String] = instance!.achievementsCacheShowAfter
            
            var achievementsTemps = [String:GKAchievement]()
            
            if achievements.count > 0 {
                
                for achievement in achievements  {
                    
                    
                    let achievementExtract = EasyGameCenter.achievementForIndentifier(identifierAchievement: achievement.1)
                    
                    achievementsTemps[achievement.1] = achievementExtract
                    
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
            println("\nError : Instance Nil\n")
            completion!(achievementShow: nil)
        } else {
            if !EasyGameCenter.isPlayerIdentifiedToGameCenter() {
                println("\nEasyGameCenter : Player not identified\n")
                if completion != nil { completion!(achievementShow: nil) }
            } else {
                if let achievementNotShow: [String:GKAchievement] = EasyGameCenter.getAchievementCompleteAndBannerNotShowing() {
                    for achievement in achievementNotShow  {
                        var oneAchievement : GKAchievement = achievement.1
                        
                        EasyGameCenter.getTupleGKAchievementAndDescription(achievementIdentifier: oneAchievement.identifier, completion: {
                            (tupleGKAchievementAndDescription) -> Void in
                            
                            if let tupleOK = tupleGKAchievementAndDescription {
                                //oneAchievement.showsCompletionBanner = true
                                let title = tupleOK.gkAchievementDescription.title
                                let description = tupleOK.gkAchievementDescription.achievedDescription
                                
                                EasyGameCenter.showCustomBanner(title: title, description: description, completion: { () -> Void in
                                    if completion != nil { completion!(achievementShow: oneAchievement) }
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
        let instance = Static.instance
        if instance == nil {
            println("\nError : Instance Nil\n")
        } else {
            if EasyGameCenter.isPlayerIdentifiedToGameCenter() {
                if let achievementInArrayInt = instance!.achievementsCache[achievementIdentifier]?.percentComplete {
                    return achievementInArrayInt
                }
            } else {
                println("\nEasyGameCenter : Player not identified\n")
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
        if EasyGameCenter.isHaveNetworkAndPlayerIdentified() {
            if let achievement = EasyGameCenter.achievementForIndentifier(identifierAchievement: achievementIdentifier) {
                GKAchievement.resetAchievementsWithCompletionHandler({
                    (var error:NSError!) -> Void in
                    
                    var validation = false
                    if error != nil {
                        println("\nCouldn't Reset achievement (\(achievementIdentifier))\n")
                        
                    } else {
                        achievement.percentComplete = 0
                        achievement.showsCompletionBanner = false
                        validation = true
                        println("\nReset achievement (\(achievementIdentifier))\n")
                        
                    }
                    if completion != nil { completion!(isResetToGameCenterOrNor: validation) }
                    
                })
            }
        } else {
            if completion != nil { completion!(isResetToGameCenterOrNor: false) }
        }
    }
    
    /**
    Remove All Achievements
    */
    class func resetAllAchievements( completion:  ((achievementReset:GKAchievement) -> Void)?)  {
        
        if EasyGameCenter.isHaveNetworkAndPlayerIdentified() {
            let gameCenter = EasyGameCenter.Static.instance!
            
            for lookupAchievement in gameCenter.achievementsCache {
                
                var achievementID = lookupAchievement.0
                EasyGameCenter.resetOneAchievement(achievementIdentifier: achievementID, completion: {
                    (isReset) -> Void in
                    if !isReset {
                        
                        if completion != nil {
                            completion!(achievementReset:lookupAchievement.1)
                        }
                    }
                })
                
            }
        }
        
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